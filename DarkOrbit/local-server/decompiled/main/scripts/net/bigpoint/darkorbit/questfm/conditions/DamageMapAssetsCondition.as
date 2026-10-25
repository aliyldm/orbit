package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class DamageMapAssetsCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var mapAssetCount:int;
      
      private var mapAssetId:Array = [];
      
      private var assetListing:String = "";
      
      private var damageTypeCount:int;
      
      private var damageTypeID:int;
      
      public function DamageMapAssetsCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc6_:String = null;
         var _loc2_:Vector.<String> = param1;
         this.mapAssetCount = int(_loc2_.shift());
         var _loc3_:Vector.<String> = _loc2_.splice(0,this.mapAssetCount);
         this.damageTypeCount = int(_loc2_.shift());
         this.damageTypeID = int(_loc2_.shift());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            this.mapAssetId[_loc4_] = _loc3_[_loc4_];
            _loc6_ = InGameCatalog.instance.getMapAssetName(this.mapAssetId[_loc4_]);
            if(_loc6_)
            {
               this.assetListing += ", " + _loc6_;
            }
            _loc4_++;
         }
         this.assetListing = this.assetListing.substring(2);
         var _loc5_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this.mapAssetCount > 0)
         {
            _loc5_ += "_spec";
         }
         _loc5_ += "_" + InGameCatalog.instance.damage_types[this.damageTypeID];
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getItem(_loc5_);
         _description = description.replace(/%map_assets%/,this.assetListing);
         if(this.mapAssetCount > 0)
         {
            _helpIconData = getBitmapDataByKey(InGameCatalog.instance.getMapAssetIcon(this.mapAssetId[0]) + "_icon.png");
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

