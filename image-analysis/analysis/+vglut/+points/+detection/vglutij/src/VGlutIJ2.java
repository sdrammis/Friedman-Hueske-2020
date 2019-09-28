import ij.*;
import ij.gui.*;
import java.awt.*;
import java.io.*;
import java.util.Arrays;

import ij.plugin.filter.ParticleAnalyzer;
import ij.plugin.frame.RoiManager;
import loci.formats.FormatException;
import loci.plugins.BF;

public class VGlutIJ2 {
    public void run(String imageFilePath, String outputDataPath, double rs, double rt, double cs, double ct) {
        ImagePlus imp;
        try {
            ImagePlus[] imps = BF.openImagePlus(imageFilePath);
            imp = imps[0];
        } catch (IOException ex) {
            System.err.println("Could not open image.");
            return;
        } catch(FormatException ex) {
            System.err.println("Could not open image. Invalid format.");
            return;
        }

        IJ.run(imp, "Enhance Contrast", "saturated=0.01");
        System.out.println("Subtracting background....");
        IJ.run(imp, "Subtract Background...", "rolling=10");

        IJ.setAutoThreshold(imp, "Default ignore_black white");
        IJ.run(imp, "Invert", "");
        IJ.run(imp, "Make Binary", "");
        System.out.println("Converting to mask....");
        IJ.run(imp, "Convert to Mask", "only");

        IJ.run(imp, "Options...", "iterations=1 count=4 do=Erode");

        System.out.println("Running Watershed....");
        IJ.run(imp, "Watershed", "");

        RoiManager rm = new RoiManager(true);// The Roi manager is not displayed
        ParticleAnalyzer.setRoiManager(rm);
        System.out.println("Running Particles....");
        IJ.run(imp, "Analyze Particles...", "size=10-Infinity pixel clear add");

        FileOutputStream fos;
        try {
            File fout = new File(outputDataPath);
            fos = new FileOutputStream(fout);
        } catch (FileNotFoundException ex){
            System.err.println("Could not file output file to write!");
            return;
        }

        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));
        int n = rm.getCount();
        for (int i=0; i<n; i++) {

            Roi roi = rm.getRoi(i);
            Polygon poly = roi.getPolygon();
            double[] centroid = roi.getContourCentroid();

            double x = centroid[0];
            double y = centroid[1];
            if (x >= cs && x <= ct && y >= rs && y <= rt) {
                try {
                    bw.write(Arrays.toString(centroid) + "\t" + Arrays.toString(poly.xpoints) + "\t" + Arrays.toString(poly.ypoints) + "\n");
                } catch (IOException ex) {
                    System.err.println("Could not write roi to file!");
                    return;
                }
            }
        }

        rm.reset();
        rm.close();
        imp.close();
        System.out.println("Done!");
    }
}