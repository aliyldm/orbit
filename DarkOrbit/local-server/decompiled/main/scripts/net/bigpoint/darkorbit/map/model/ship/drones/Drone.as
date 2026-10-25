package net.bigpoint.darkorbit.map.model.ship.drones
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class Drone
   {
      
      private static const STANDARD_ASSET:String = "standard";
      
      private static const simpleDroneDisplayLetterMap:Dictionary = new Dictionary();
      
      simpleDroneDisplayLetterMap[1] = "F";
      simpleDroneDisplayLetterMap[2] = "I";
      simpleDroneDisplayLetterMap[3] = "A";
      simpleDroneDisplayLetterMap[4] = "Z";
      
      private var _index:int;
      
      private var _type:int;
      
      private var _visualDesign:DroneDesign;
      
      private var _statsDesign:DroneDesign;
      
      private var _level:int;
      
      public function Drone(param1:int, param2:int, param3:DroneDesign, param4:DroneDesign, param5:int)
      {
         super();
         this._index = param1;
         this._type = param2;
         this._visualDesign = param3;
         this._statsDesign = param4;
         this._level = param5;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get statsDesign() : DroneDesign
      {
         return this._statsDesign;
      }
      
      public function get visualDesign() : DroneDesign
      {
         return this._visualDesign;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get simpleRepresentation() : String
      {
         return "<font color=\'#" + this._statsDesign.color.toString(16) + "\'>" + (simpleDroneDisplayLetterMap[this._type] || "") + "</font>";
      }
      
      public function get uberAssetDescriptor() : XML
      {
         return UberAssetsLib.instance.getDescriptor(this.uberAssetDescriptorId,UberAssetsLib.LIB_DRONES,false) || UberAssetsLib.instance.getDebugDescription();
      }
      
      public function get uberAssetDescriptorId() : String
      {
         var _loc1_:Vector.<String> = Vector.<String>([this._type + "_" + this._visualDesign.assetId + "_" + this._level,this._type + "_" + this._visualDesign.assetId,this._visualDesign.assetId]);
         var _loc2_:Vector.<String> = Vector.<String>([this._type + "_" + this._statsDesign.assetId + "_" + this._level,this._type + "_" + this._statsDesign.assetId,this._statsDesign.assetId]);
         var _loc3_:Vector.<String> = _loc1_;
         if(this._statsDesign.assetId != STANDARD_ASSET && this._visualDesign.assetId == STANDARD_ASSET)
         {
            _loc3_ = _loc2_;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(UberAssetsLib.instance.getDescriptor(_loc3_[_loc4_],UberAssetsLib.LIB_DRONES,false) != null)
            {
               return _loc3_[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      public function equals(param1:Drone) : Boolean
      {
         return this._index == param1.index && this._type == param1.type && this._visualDesign == param1.visualDesign && this._statsDesign == param1.statsDesign && this._level == param1.level;
      }
      
      public function visualyEquals(param1:Drone) : Boolean
      {
         return this.uberAssetDescriptorId == param1.uberAssetDescriptorId;
      }
   }
}

