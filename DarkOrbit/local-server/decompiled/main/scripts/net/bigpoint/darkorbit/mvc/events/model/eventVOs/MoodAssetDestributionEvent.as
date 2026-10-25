package net.bigpoint.darkorbit.mvc.events.model.eventVOs
{
   public class MoodAssetDestributionEvent extends MoodAssetEvent
   {
      
      public static const ICEBERG_MOOD_ASSET_LIB_ID:String = "iceBergAssetDefinition";
      
      private var _types:Vector.<String>;
      
      public function MoodAssetDestributionEvent(param1:uint, param2:Boolean, param3:String, param4:Vector.<String>)
      {
         super(param1,param2,param3);
         this._types = param4;
      }
      
      public function get types() : Vector.<String>
      {
         return this._types;
      }
   }
}

