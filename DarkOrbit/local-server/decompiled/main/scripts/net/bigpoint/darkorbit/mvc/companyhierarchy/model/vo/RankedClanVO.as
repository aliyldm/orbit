package net.bigpoint.darkorbit.mvc.companyhierarchy.model.vo
{
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class RankedClanVO implements IRankedClanViewData
   {
      
      private var _rank:int;
      
      private var _position:String;
      
      private var _clan:String;
      
      private var _clanId:int;
      
      private var _leader:String;
      
      private var _points:int;
      
      private var _logoURL:String;
      
      private var _cbsNamesAndLocations:String;
      
      public function RankedClanVO(param1:int, param2:String, param3:String, param4:String, param5:int, param6:int = 0, param7:String = "-")
      {
         super();
         this._rank = param1;
         this._position = param2;
         this._clan = param3;
         this._clanId = param6;
         this._leader = param4;
         this._points = param5;
         this._logoURL = Settings.sharedImagesHost + "/clanLogo/" + Settings.instanceID + "/clan_" + Settings.instanceID + "_" + param6 + ".gif";
         this._cbsNamesAndLocations = param7;
      }
      
      public function get rank() : int
      {
         return this._rank;
      }
      
      public function get position() : String
      {
         return this._position;
      }
      
      public function get clan() : String
      {
         return this._clan;
      }
      
      public function get clanId() : int
      {
         return this._clanId;
      }
      
      public function get leader() : String
      {
         return this._leader;
      }
      
      public function get points() : int
      {
         return this._points;
      }
      
      public function get logoURL() : String
      {
         return this._logoURL;
      }
      
      public function get cbsNamesAndLocations() : String
      {
         return this._cbsNamesAndLocations;
      }
   }
}

