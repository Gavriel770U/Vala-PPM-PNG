/*
    Author: Gavriel Linoy, 2023

    Compilation And Conversion To .exe:
    valac -o graphics --pkg posix graphics.vala
    
    Run .exe:
    ./graphics.exe
*/

using Posix;

public class RGB
{
    public uint8 red;
    public uint8 green;
    public uint8 blue;
        
    public RGB(uint8 red, uint8 green, uint8 blue)
    {
        this.red = red;
        this.green = green;
        this.blue = blue;
    }
}

const int RGB_SIZE = 3;

public static void initialize_rgb_data(RGB[] rgb_data, uint8 red, uint8 green, uint8 blue)
{
    int i = 0;
    for(i = 0; i < rgb_data.length; i++)
    {
        rgb_data[i] = new RGB(red, green, blue);
    }
} 

public static void copy_rgb_data_to_image_data(uint8[] image_data, RGB[] rgb_data, int settings_length)
{
    int i = settings_length;
    for(i = i; i < image_data.length; i += RGB_SIZE)
    {
        image_data[i] = rgb_data[(i-settings_length)/(int)(RGB_SIZE)].red;
        image_data[i+1] = rgb_data[(i-settings_length)/(int)(RGB_SIZE)].green;
        image_data[i+2] = rgb_data[(i-settings_length)/(int)(RGB_SIZE)].blue;
    }
}

public static void write_to_ppm(string image_path, uint8[] image_data)
{
    FileStream file_stream = FileStream.open(image_path, "wb");

    if (file_stream == null) 
    {
        GLib.stderr.printf("Failed to create the file stream\n");
        return;
    }

    file_stream.write(image_data, 1);
}

public static int main(string[] args) 
{   
    string ppm_path = "./image.ppm";
     
    string IMAGE_WIDTH_STR = "400";
    string IMAGE_HEIGHT_STR = "300";
    string FORMAT = "P6";
    string BY_AUTHOR = "#by Gavriel";
    string RGB_MAX_VALUE = "255";
    string NEW_LINE = "\n";
    string SPACE = " ";

    int IMAGE_WIDTH = int.parse(IMAGE_WIDTH_STR);
    int IMAGE_HEIGHT = int.parse(IMAGE_HEIGHT_STR);
     
    string SETTINGS = FORMAT + NEW_LINE + BY_AUTHOR + NEW_LINE + IMAGE_WIDTH_STR + SPACE + IMAGE_HEIGHT_STR + NEW_LINE + RGB_MAX_VALUE + NEW_LINE;
    int settings_length = SETTINGS.length;

    print("%s\n", SETTINGS);
    print("%d\n", settings_length);

    uint8[] image_data = new uint8[settings_length + (IMAGE_WIDTH * IMAGE_HEIGHT * RGB_SIZE)];
    RGB[] rgb_data = new RGB[IMAGE_WIDTH * IMAGE_HEIGHT];

    for(int i = 0; i<settings_length; i++)
    {
        image_data[i] = SETTINGS[i];
    }

    initialize_rgb_data(rgb_data, 0, 0, 0);
    copy_rgb_data_to_image_data(image_data, rgb_data, settings_length);
    write_to_ppm(ppm_path, image_data);

    string command = "convert " + ppm_path + " output.png";

    Posix.system(command);

    return 0;
}