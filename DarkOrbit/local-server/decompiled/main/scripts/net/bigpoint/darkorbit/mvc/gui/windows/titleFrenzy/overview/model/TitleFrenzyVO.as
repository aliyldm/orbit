package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.model
{
   import net.bigpoint.darkorbit.com.module.TitleFrenzyOwnerUpdateCommand;
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class TitleFrenzyVO
   {
      
      private var _mapId:int;
      
      private var _mapName:String;
      
      private var _titleId:int;
      
      private var _username:String;
      
      public function TitleFrenzyVO(param1:TitleFrenzyOwnerUpdateCommand)
      {
         super();
         this.mapId = param1.mapId;
         this._titleId = param1.titleId;
         this.username = param1.username;
      }
      
      public static function sort(param1:TitleFrenzyVO, param2:TitleFrenzyVO) : int
      {
         if(param1.hasOwner == param2.hasOwner)
         {
            return param1.titleId - param2.titleId;
         }
         return param1.hasOwner ? -1 : 1;
      }
      
      public function get infoText() : String
      {
         return this._username + " (" + this._mapName + ")";
      }
      
      public function set mapId(param1:int) : void
      {
         this._mapId = param1;
         this._mapName = Map.getMissionMapName(this._mapId);
      }
      
      public function get titleId() : int
      {
         return this._titleId;
      }
      
      public function get hasOwner() : Boolean
      {
         return this._username != "";
      }
      
      public function set username(param1:String) : void
      {
         this._username = param1;
      }
   }
}

