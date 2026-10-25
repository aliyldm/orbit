package net.bigpoint.darkorbit.pattern
{
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ResourcePattern extends Pattern
   {
      
      private var _resKey:String;
      
      private var _resKeyStarling:String;
      
      private var _atlasXml:String;
      
      private var preload:Boolean;
      
      private var _poolSize:int;
      
      public function ResourcePattern(param1:int, param2:String, param3:String = null, param4:String = null)
      {
         super(param1);
         this._resKey = param2;
         this._resKeyStarling = param3;
         this._atlasXml = param4;
      }
      
      public function getResKey() : String
      {
         return this.resKey;
      }
      
      public function setPreload(param1:Boolean) : void
      {
         this.preload = param1;
      }
      
      public function set resKey(param1:String) : void
      {
         this._resKey = param1;
      }
      
      public function get resKey() : String
      {
         return Settings.gpuSupport ? this._resKeyStarling || this._resKey : this._resKey;
      }
      
      public function get resKeyStarling() : String
      {
         return this._resKeyStarling;
      }
      
      public function get atlasXml() : String
      {
         return this._atlasXml;
      }
      
      public function get poolSize() : int
      {
         return this._poolSize;
      }
      
      public function set poolSize(param1:int) : void
      {
         this._poolSize = param1;
      }
   }
}

