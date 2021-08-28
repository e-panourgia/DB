package DB;
/**
*
*This java programm takes a customer code from.
*the user and delete it.
*Checks if the customer code is existing and
*handling likewise.
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


public class Java1 { //beggining of class

	public static void main(String [] args) { //beggining of main

	//Declaration of objects and variables
	Scanner sc = new Scanner(System.in);

	/**Variables that suts with the columns of our SQL */
	int delete_customer;
	//
	int cust_code;


	String url = "jdbc: -#-#-#...";
	Connection dbcon;

	Statement stmt;
	Statement stmt2;
	ResultSet rs2;

	//declare ODBC connection
	try{
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	}
	catch(java.lang.ClassNotFoundException e)
	{
		System.out.print("ClassNotFoundException:");
		System.out.print(e.getMessage());
	}

	//interruction with the user
	System.out.println("Please, insert customer's code ");
	System.out.print("The customer code is: ");
	delete_customer = sc.nextInt();
	System.out.println();

	//execute SQL statement
	try{
		dbcon = DriverManager.getConnection(url);

		stmt = dbcon.createStatement();
		stmt2 = dbcon.createStatement();

		PreparedStatement 	rs = dbcon.prepareStatement("DELETE FROM Customer WHERE CustCode = "+delete_customer+" ");
		//rs.executeUpdate();


		int counter_unsucess =0;
		//if an den iparxei
		rs2 = stmt2.executeQuery("SELECT CustCode FROM Customer WHERE CustCode = "+delete_customer+" ");
		rs.executeUpdate();
		while (rs2.next()) {

			cust_code = rs2.getInt("CustCode");
			if(cust_code == delete_customer){
				System.out.println("The customer with given custcode deleted sucessfully!");
				++counter_unsucess;
				break;
			}
		}//ending of while
		//System.out.println("The customer with given custcode deleted sucessfully!");
		if(counter_unsucess == 0){
			System.out.println("The customer with given custcode has not being deleted FAILED!");
		}
		JOptionPane.showMessageDialog(null,"Our programm ends here, Thank you!");
		//closes
		//rs.executeUpdate();
		rs.close();
		stmt.close();
	    dbcon.close();
	}//ending of try

	catch(SQLException e)
	{
		System.out.print("SQLEXCEPTION:");
		System.out.println(e.getMessage());
	}//ending of catch

	} //ending of main
} //ending of class
