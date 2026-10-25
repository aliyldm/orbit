package net.bigpoint.darkorbit.mvc.events.model.eventVOs
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.EventActivationMapExchangeAttributeModule;
   import net.bigpoint.darkorbit.mvc.events.model.interfaces.IDOEvent;
   
   public class MapReplacementEvent implements IDOEvent
   {
      
      private static const _replacementsMapping:Array = getMapping();
      
      private var _id:int;
      
      private var _active:Boolean;
      
      private var _mapReplacements:Dictionary;
      
      public function MapReplacementEvent(param1:int, param2:Boolean, param3:Dictionary)
      {
         super();
         this._mapReplacements = param3;
         this._active = param2;
         this._id = param1;
      }
      
      private static function getMapping() : Array
      {
         var _loc1_:Array = [];
         _loc1_[EventActivationMapExchangeAttributeModule.REPLACEMENTTYPE_FOOTBALL_4_4] = "football_4-4";
         _loc1_[EventActivationMapExchangeAttributeModule.REPLACEMENTTYPE_FOOTBALL_INVASION] = "football_invasion";
         _loc1_[EventActivationMapExchangeAttributeModule.REPLACEMENTTYPE_FOOTBALL_TDM] = "football_tdm";
         return _loc1_;
      }
      
      public static function getMapResKey(param1:uint) : String
      {
         return _replacementsMapping[param1] || null;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get isActive() : Boolean
      {
         return this._active;
      }
      
      public function get mapReplacements() : Dictionary
      {
         return this._mapReplacements;
      }
   }
}

