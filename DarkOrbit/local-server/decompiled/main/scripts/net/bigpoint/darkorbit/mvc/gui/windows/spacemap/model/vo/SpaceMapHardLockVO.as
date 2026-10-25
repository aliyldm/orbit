package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo
{
   public class SpaceMapHardLockVO
   {
      
      private var _status:Boolean;
      
      private var _obfuscateMapData:Boolean;
      
      public function SpaceMapHardLockVO(param1:Boolean, param2:Boolean)
      {
         super();
         this._status = param1;
         this._obfuscateMapData = param2;
      }
      
      public function get status() : Boolean
      {
         return this._status;
      }
      
      public function set status(param1:Boolean) : void
      {
         this._status = param1;
      }
      
      public function get obfuscateMapData() : Boolean
      {
         return this._obfuscateMapData;
      }
      
      public function set obfuscateMapData(param1:Boolean) : void
      {
         this._obfuscateMapData = param1;
      }
   }
}

