package DB;
/**
*
*This java programm takes an order code.
*from the user and.
*if exists in  database
*prints suitable invoice
*in case not appears suitable message.
*
*GUI involved.
*
*This java programm conects with SQLServer.
*
*/

import java.io.*;
import java.text.*;
import java.util.*;
import java.sql.*;
import javax.swing.JOptionPane;


public class Java2 { //beggining of class

	public static void main(String [] args) { //beggining of main

	//Declaration of objects and variables
	Scanner sc = new Scanner(System.in);

	/**Variables that suts with the columns of our SQL */
	int order_code;
	int ordercode;
	String name;
	int amount;
	double price;
	double pay_per_product;
	double total;
	String customer;

	String url = "jdbc: ... ;";
	Connection dbcon;
	Statement stmt;
	ResultSet rs;

	//declare ODBC connection
	try{
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	}
	catch(java.lang.ClassNotFoundException e)
	{
		System.out.print("ClassNotFoundException:");
		System.out.print(e.getMessage());
	}

	//interaction with the user
	System.out.println("Please, insert order code ");
	System.out.print("The order code is: ");
	order_code = sc.nextInt();
	System.out.println();

	//execute SQL statement
	try{
		dbcon = DriverManager.getConnection(url);
		stmt = dbcon.createStatement();
		rs = stmt.executeQuery("SELECT co.OrdCode, p.Name , co.Amount, P.Price, (co.Amount * p.Price) Pay_Per_Product, c.CompName "+
		"FROM ConsistOf  co, Product  p, Orderr o, Customer c "+
		"WHERE co.OrdCode = o.OrdCode AND p.PrCode = co.PrCode AND c.CustCode = o.CustCode AND co.OrdCode = "+order_code+" ");
		int check1 = 0; //in order to appear in the beggining the  Order code one time at printing
		//double pp;
		int at_least_one_time = 0; //in order to appear suitable message if there is not data for given order code
		System.out.printf("%30s","Invoice");
		System.out.println();


		while (rs.next()) {

			ordercode = rs.getInt("OrdCode");
			name = rs.getString("Name");
			amount = rs.getInt("Amount");
			price = rs.getDouble("Price");
    		pay_per_product = rs.getDouble("Pay_Per_Product");


	 		//print data the first time time of looping
	 		if(check1 == 0) {
				//name of our company
			System.out.println("--------------------------------------------------------------------------");
			System.out.println("Shop-Spare Parts");
			System.out.println("Adress : Kyceli, 52");

			customer = rs.getString("CompName");
			System.out.printf("Company  Name : %s",customer);

			System.out.println();
			System.out.println("-------------------------------------------------------------------------");

	 		//System.out.printf("Order Code: %d",ordercode);
			System.out.printf("%s","Ord");
			System.out.printf("%2s","|");//|
			System.out.printf("%s","Amount");
			System.out.printf("%1s","|");//|
			System.out.printf("%s","Price");
			System.out.printf("%6s","|");//|
			System.out.printf("%s","Pay Per Product");
			System.out.printf("%1s","|");//|
			System.out.printf("Name");


			//System.out.printf("%s","Ttotal Pay");
			//System.out.printf("%3s","|");//|
            //two metodss
			++check1;
			System.out.println();
			}

			//prints data every time of looping
			if(ordercode < 10){
	 		System.out.printf("%d",ordercode);
			System.out.printf("%4s","|");//|
			}else{
			System.out.printf("%d",ordercode);
	 		System.out.printf("%3s","|");//|
			}
			//amount 1..2cifia
			if(amount < 10){
				System.out.printf("%d",amount);
				System.out.printf("%6s","|");//|
			}else if(amount < 100){

				System.out.printf("%d",amount);
				System.out.printf("%5s","|");//|
			}else{

				System.out.printf("%d",amount);
				System.out.printf("%4s","|");//|
			}
			//price
			if(price < 100){
				System.out.printf("%f",price);
				System.out.printf("%2s","|");//|
			}else{
				System.out.printf("%f",price);
				System.out.printf("%1s","|");//|
			}
			//Pay Per Product
			if(pay_per_product < 1000){
				System.out.printf("%f",pay_per_product);
	 			System.out.printf("%6s","|");//|
			}else if(pay_per_product < 10000){
				System.out.printf("%f",pay_per_product);
	 			System.out.printf("%5s","|");//|
			}else{
				System.out.printf("%f",pay_per_product);
	 			System.out.printf("%4s","|");//|
			}
			//name
			System.out.printf("%s",name);
			System.out.println();
			++at_least_one_time;
	} //ending of looping

		if(at_least_one_time == 0) {
			//appears box the suitable message
			JOptionPane.showMessageDialog(null,"--There is not data for this order code--");
		}

		//closes
		rs.close();
		stmt.close();
		dbcon.close();
		JOptionPane.showMessageDialog(null,"Our programm ends here, Thank you!");
	}//ending of try
	catch(SQLException e)
	{
		System.out.print("SQLEXCEPTION:");
		System.out.println(e.getMessage());
	}//ending of catch

	} //ending of main
} //ending of class

