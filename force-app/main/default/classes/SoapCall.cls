/*****

It points to a real, free, live public SOAP service at https://www.dataaccess.com with two methods:

upload thr wsdl file in setup-> generate from wsdl
remote site settin-> new remote site setting; name:dataAccessService, remote site url: https://www.dataaccess.com

This has 2 methods
NumberToWords(integer number)
NumberToDollars(decimal number)

// Create the stub (the generated class acts as your client)
NumberConversion.NumberConversionSoap stub = new NumberConversion.NumberConversionSoap();

// --- Test 1: Number to Words ---
String words = stub.NumberToWords(12345);
System.debug('Number to Words: ' + words);
// Output: "twelve thousand three hundred and forty five "

// --- Test 2: Number to Dollars ---
String dollars = stub.NumberToDollars(99.50);
System.debug('Number to Dollars: ' + dollars);
// Output: "ninety nine dollars and fifty cents"


***/
public class SoapCall {
    

}