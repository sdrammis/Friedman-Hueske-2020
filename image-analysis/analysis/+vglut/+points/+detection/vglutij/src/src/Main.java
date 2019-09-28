public class Main {
    public static void main(String[] args) {
        String imageFilePath = "/home/sdrammis/scratch/test-tiled.tiff";
        String outputDataPath = "/home/sdrammis/scratch/out.csv";

        VGlutIJ vglutij = new VGlutIJ();
        vglutij.run(imageFilePath, outputDataPath, 4096, 8192, 2730, 5460);
    }
}
