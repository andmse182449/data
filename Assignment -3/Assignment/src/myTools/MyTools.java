/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package myTools;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Scanner;

/**
 *
 * @author a
 */
public class MyTools {
   public static final Scanner sc = new Scanner(System.in);
 
//------------------------------------------------------------------------------
   
   /**Parsing the input String to get the boolean data (true/false)
    * @param input: String
    * @return true if the first character of the input is 'Y' || 'T' || '1'
    */
   public static boolean parseBoolean(String input){
       input = input.trim().toUpperCase(); //Chuẩn hóa chuỗi nhập
       char c = input.charAt(0); //lấy kí tự đầu của chuỗi
       return c == 'Y' || c == '1' || c == 'T';
   }
   //Biến String nhập True/False của người dùng thành giá trị Boolean thật, xài được
   
 
//------------------------------------------------------------------------------
   
   
   /** Normalizing the date String: Using '-' to seperate date parts only
    * @param dateStr: input date String
    * @return new String
    */
   public static String normalizeDateStr(String dateStr){
       String result = dateStr.replaceAll("[\\s]+", "");
       //result sẽ bằng dateStr nhưng xóa hết những khoảng trống.
       //khoảng trống là \\s và dấu '+' là xuất hiện nhiều hơn 1 lần.
       //nếu có xuất hiện khoảng trống và có thể xuất hiện nhiều lần thì thay bằng "", tức là xóa
       
       result = result.replaceAll("[./-]+", "-");
       //Thay thế hết mấy dấu / - . | thành - để chuẩn hóa chuỗi ngày tháng
       
       return result;
   }
   //Chuẩn hóa chuỗi ngày tháng năm thành dạng đúng, vì người dùng có thể nhập sai
   //Ví dụ ngày 7 tháng 2 năm 2023 thì ngta có thể ghi 07/02/2023 || 07|02|2023 || 07.02.2023 || 07-02-2023
   //Lúc đó mình sẽ chuyển lại thành 1 kiểu nhất định là 07-02-2023.
   
//------------------------------------------------------------------------------
   
   
   /**Parsing the input String into Date data
    * @param inputStr: date String input
    * @param dateFormat: format that you want the Date to be
    * @return a date object with the same format with dateFormat.
    */
   public static Date parseDate(String inputStr, String dateFormat){
       inputStr = normalizeDateStr(inputStr); //Chuẩn hóa chuỗi Date
       DateFormat formatter = new SimpleDateFormat(dateFormat);
       //Tạo biến formatter sẽ chuyển inputStr thành 1 object với thuộc tính Date và format theo định dạng của dateFormat mà ta truyền vào 
       try{
           return formatter.parse(inputStr);
       }catch(ParseException e){ //các lỗi liên quan đến ép kiểu sẽ được catch ở đây
           System.err.println(e);
       }
       return null; //không phân tích thành công thì trả về null
   }
   //Biến chuỗi Date người dùng nhập thành kiểu dữ liệu date thiệt. Với format theo biến dateFormat mà mình nhập
   //Format có thể là MM-DD-YYYY || DD-MM-YYYY || YYYY-MM-DD
   
//------------------------------------------------------------------------------
   
   /**Convert a Date object to String with the given date format
    * @param date: Date object needs to be converted to String
    * @param dateFormat: the format using to convert
    * @return String of a Date object using the give date format.
    */
    public static String toString(Date date, String dateFormat){
        if (date == null) return "";
        //Tạo DateFormat để làm việc với định dạng ở tham số thứ hai
        DateFormat formatter = new SimpleDateFormat(dateFormat);
        //Chuyển object Date thành định dạng đã nhập ở tham số thứ hai.
        return formatter.format(date);
    }
    //Chuyển ngược date object thành String với định dạng mình chọn
    
    
 //-----------------------------------------------------------------------------
    
    /** Get the year part of the date
     * @param d: the Date we need to get year
     * @param calendarPart: Part of the calendar we need to get, in this situation is the Year
     * @return the Year of the Date
     */
    public static int getPart(Date d, int calendarPart){
        Calendar cal = new GregorianCalendar();
        cal.setTime(d);
        return cal.get(calendarPart);
    }
    
    
//------------------------------------------------------------------------------
    
    
//METHODS FOR READING DATA FROM KEYBOARD
    /** Reading boolean data */
    public static boolean readBoolean(String prompt){
        System.out.println(prompt + ": ");
        return parseBoolean(sc.nextLine());
    }
    
//------------------------------------------------------------------------------
    
    
    /** Reading a String using a pre-defined pattern
     * @param prompt: guide user to input the String
     * @param pattern: pre-defined pattern for input
     * @return an input String which matches the pattern
     */
    public static String readStr(String prompt, String pattern){
        String input;
        boolean valid = false;
        do{
            System.out.println(prompt + ": ");
            input = sc.nextLine().trim();
            valid = input.matches(pattern);
        }while(valid == false);
        return input;
    }
    
  
//------------------------------------------------------------------------------
    
    
    public static Date readDate(String prompt, String dateFormat){
        String input;
        Date d;
        do{
            System.out.println(prompt + ": ");
            input = sc.nextLine().trim();
            d = parseDate(input, dateFormat);
            if (d == null) System.out.println("The data is not valid");         
        }while(d == null);
        return d;
    }
    
    // Nhập ngày tháng sau 1 ngày cho trước
    public static Date readDateAfter(String prompt, String dateFormat, Date markerDate) {
        String input;
        Date d;
        boolean ok = false;
        do {
            System.out.println(prompt + ": ");
            input = sc.nextLine().trim();
            d = parseDate(input, dateFormat);
            ok = (d != null && d.after(markerDate));
            if (d == null) {
                System.out.println("Date data is not valid");
            }
            if(!ok) System.out.println("Date after is not valid !");
        } while (!ok);
        return d;
    }

//------------------------------------------------------------------------------    
    
    
    // Nhập ngày tháng trước 1 ngày cho trước    
    public static Date readDateBefore(String prompt, String dateFormat, Date markerDate) {
        String input;
        Date d;
        boolean ok = false;
        do {
            System.out.println(prompt + ": ");
            input = sc.nextLine().trim();
            d = parseDate(input, dateFormat);
            ok = ((d != null && d.before(markerDate)) || d.equals(markerDate));
            if (d == null) {
                System.out.println("Date data is not valid");
            }
            if(!ok) System.out.println("Date before is not valid !");
        } while (!ok);
        return d;
    }

    
//------------------------------------------------------------------------------    
    
    //Tạo ra code bất kì  
    public static String generateCode(String prefix, int length, int curNumber) {
        String formatStr = "%0" + length + "d";
        return prefix + String.format(formatStr, curNumber);
    }

//------------------------------------------------------------------------------    
    
//TEST    
    
    
    public static void main(String[] args) {
        System.out.println("Test boolean string:");
        System.out.println(parseBoolean("        TrUe        "));
        System.out.println(parseBoolean("    fAlSe           "));
        System.out.println(parseBoolean("      1234          "));
        System.out.println(parseBoolean("      01 23          "));
        System.out.println(parseBoolean("      total          "));
        System.out.println(parseBoolean("      cosine          "));
        System.out.println("Test normalizeDateStr(String): ");
        String s = " 7 ... --- 2 / 2023   ";
        System.out.println(s + "--> " + normalizeDateStr(s));
        s = "7 ...2 //// 2023  ";
        System.out.println(s + "--> " + normalizeDateStr(s));
        System.out.println("\nTest Date <--> String: ");
        String[] format = {"yyyy-MM-dd", "MM-dd-yyyy", "dd-MM-yyyy"};
        String[] dStrs = {"2023-02-21", "12.--25-2023", "7 .. 2// 2023"};
        Date d = null;
        for (int i = 0; i < 3; i++) {
            System.out.println(dStrs[i] + "(" + format[i] + ")");
            d = parseDate(dStrs[i], format[i]);
            if (d != null) {
                System.out.println("Year: " + getPart(d, Calendar.YEAR));
                System.out.println("--> Result: " + d);
                System.out.println("---> in the format " + format[i] + ": " + toString(d, format[i]));
            } else {
                System.out.println("Parsing error!");
            }
        }
        System.out.println("Test reading a boolean data");
        boolean b = readBoolean("Input a boolean data (T/F, 1/0, Y/N)");
        System.out.println(b + " inputted");
        System.out.println("Test input a date data");
        d = readDate("Input a data (dd-mm-yyyy)", "dd-MM-yyyy");
        System.out.println("Inputted date: ");
        System.out.println("In format dd-MM-yyyy: " + toString(d, "dd-MM-yyyy"));
        System.out.println("In format MM-dd-yyyy: " + toString(d, "MM-dd-yyyy"));
        System.out.println("In format yyyy-MM-dd: " + toString(d, "yyyy-MM-dd"));
        String phoneNo = readStr("Phone number(9..11) digits", "[\\d]{9,11}");
        System.out.println("Inputted phone no, :" + phoneNo);
        System.out.println("testting for generating an automatic code");
        String prefix = "P";
        int curNumber = 25;
        int len = 7;
        String code = generateCode(prefix, len, curNumber);
        curNumber++;
        System.out.println("Generate code: " + code);
        code = generateCode(prefix, len, curNumber);
        System.out.println("Generate code: " + code);
        System.out.println("Testing reading date date before and after today");
        Date today = new Date();
        System.out.println("Today: " + MyTools.toString(d, "dd-MM-yyyy"));
        Date dBefore = MyTools.readDateBefore("Date before today", "dd-MM-yyyy", today);
        System.out.println(MyTools.toString(dBefore, "dd-MM-yyyy"));
        Date dAfter = MyTools.readDateAfter("Date after today", "dd-MM-yyyy", dBefore);
        System.out.println(MyTools.toString(dAfter, "dd-MM-yyyy"));
    }
}

