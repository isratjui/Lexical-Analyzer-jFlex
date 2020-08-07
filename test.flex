//user code
import java.util.*;

%%
// options & dec.
%standalone // this creates the main method, so don't have to create one
%class test
  
whitespaces = [ \t\n]* // these will considered as white spaces
keywords = [a-zA-Z]+[0-9]*(".")?[0-9]*[a-zA-Z]*[0-9]* // keywords, identifiers all are catched here. the "." is for stdio.h
numbers = [0-9]+(".")?[0-9]* // for numbers
mathoperators = ("++" | "--" | "+" | "-" | "*" | "/" | "=")*
logicaloperators = ("==" | "<=" | ">=" | "<" | ">")*
brackets = [(){}]*
    
%{
    
// this is copied directly into java source code
    boolean checkstring = false; // to check if a " is seen already, if the flag is true, then we have already seen a " and this " marks the end of the string
// if not then everything upto the next " is to be held for string
    
    String string = ""; // to get everything between two "
    LinkedList keywordslist = new LinkedList(); // holds keywords
    LinkedList functionslist = new LinkedList(); // holds functions
    LinkedList identifierslist = new LinkedList();
    LinkedList stringslist = new LinkedList();
    LinkedList numberslist = new LinkedList();
    LinkedList mathoperatorslist = new LinkedList();
    LinkedList logicaloperatorslist = new LinkedList();
    LinkedList bracketslist = new LinkedList();
    HashSet others = new HashSet(); // holds ; #
    
    String[] functionsarray = {"main", "printf", "scanf"}; 
    String[] keywordsarray = {"int", "float", "double", "if", "else", "for", "return", "include"};
    
    
%}
  
%eof{
    
// this is run by jflex when the end of file is reached. all the elements of all the linkedlists are just printed in proper order, exactly once
    
    System.out.print("\nKeywords: ");
    for(int i=0;i<keywordslist.size();i++){
      System.out.print(keywordslist.get(i)+" ");
    }
    
    System.out.print("\nFunctions: ");
    for(int i=0;i<functionslist.size();i++){
      System.out.print(functionslist.get(i)+" ");
    }
    
    System.out.print("\nIdentifiers: ");
    for(int i=0;i<identifierslist.size();i++){
      System.out.print(identifierslist.get(i)+" ");
    }
    
    System.out.print("\nStrings: ");
    for(int i=0;i<stringslist.size();i++){
      System.out.print(stringslist.get(i)+" ");
    }
    
    
    System.out.print("\nNumerical values: ");
    for(int i=0;i<numberslist.size();i++){
      System.out.print(numberslist.get(i)+" ");
    }
    
    System.out.print("\nMath Operators: ");
    for(int i=0;i<mathoperatorslist.size();i++){
      System.out.print(mathoperatorslist.get(i)+" ");
    }
    
    System.out.print("\nLogical Operators: ");
    for(int i=0;i<logicaloperatorslist.size();i++){
      System.out.print(logicaloperatorslist.get(i)+" ");
    }
    
    System.out.print("\nBrackets: ");
    for(int i=0;i<bracketslist.size();i++){
      System.out.print(bracketslist.get(i)+" ");
    }
    
    System.out.print("\nOthers: ");
    for(Object o : others){
      System.out.print(o+" ");
    }
%eof}
  
%%
//rules
    
    "stdio.h" {keywordslist.add("stdio.h");} // catch sdtio.h
  
  // for all the rules, first checking if the string flag is true, to decide whether they are keywords or part of a string
  
  \" { // catch "
    if(checkstring){
      //end mark
      checkstring = false;
      stringslist.add(string);
      string = "";
    }else{
      //start mark
      checkstring = true;
    }
  }
  
  {whitespaces} {
    if(checkstring){
      string += yytext();
    }
  }
  
  {numbers} {
    if(checkstring){
      string += yytext();
    }else{
      numberslist.add(yytext());
    }
    
  }
  
  {keywords} {
    
    if(checkstring){
      string += yytext();
    }else{
      String str = yytext().trim();
      boolean flag = false;
      for(int i=0;i<functionsarray.length;i++){
        if(functionsarray[i].equals(str)){
          functionslist.add(str);
          flag = true;
          break;
        }
      }
      if(!flag){
        for(int i=0;i<keywordsarray.length;i++){
          if(keywordsarray[i].equals(str)){
            keywordslist.add(str);
            flag = true;
            break;
          }
        }
      }
      
      if(!flag){
        identifierslist.add(str);
      }
    }
    
    
  }
  
  
  {mathoperators} {
    if(checkstring){
      string += yytext();
    }else{
      mathoperatorslist.add(yytext());
    }
    
  }
  
  {logicaloperators} {
    
    if(checkstring){
      string += yytext();
    }else{
      logicaloperatorslist.add(yytext());
    }
    
  }
  {brackets} {
    
    if(checkstring){
      string += yytext();
    }else{
      bracketslist.add(yytext());
    }
    
  }
  
  . {
    
    if(checkstring){
      string += yytext();
    }else{
      others.add(yytext());
    }
    
  }
  
