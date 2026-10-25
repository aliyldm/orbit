package net.bigpoint.darkorbit.mvc.companyhierarchy.model.vo
{
   public interface IRankedClanViewData
   {
      
      function get rank() : int;
      
      function get position() : String;
      
      function get clan() : String;
      
      function get leader() : String;
      
      function get points() : int;
      
      function get logoURL() : String;
      
      function get cbsNamesAndLocations() : String;
   }
}

