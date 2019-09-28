import ij.*;
import ij.gui.*;
import java.awt.*;
import java.io.*;
import java.util.Arrays;

import ij.plugin.filter.ParticleAnalyzer;
import ij.plugin.frame.RoiManager;
import ij.process.ImageProcessor;
import loci.formats.FormatException;
import loci.plugins.BF;

public class VGlutIJ {
    public void run(String imageFilePath, String outputDataPath, double rs, double rt, double cs, double ct) {
        ImagePlus imp;
        try {
            ImagePlus[] imps = BF.openImagePlus(imageFilePath);
            imp = imps[0];
        } catch (IOException ex) {
            System.err.println("Could not open image.");
            return;
        } catch( FormatException ex) {
            System.err.println("Could not open image. Invalid format.");
            return;
        }


        // TODO: Find the correct options to run with.
//        IJ.run(imp, "Options", "iterations=1 count=1 black edm=Overwrite");

        IJ.run(imp, "Enhance Contrast", "saturated=0.01");
        IJ.run(imp, "Invert", "");
        IJ.setAutoThreshold(imp, "Default ignore_black white");
        IJ.run(imp, "Make Binary", "");

        System.out.println("Converting to mask....");
        IJ.run(imp, "Convert to Mask", "only");

        System.out.println("Running Watershed....");
        IJ.run(imp, "Watershed", "");

        System.out.println("Running Particles....");

        RoiManager rm = new RoiManager(true);// The Roi manager is not displayed
        ParticleAnalyzer.setRoiManager(rm);
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
        System.out.println("Done!");
        rm.close();
    }
}
