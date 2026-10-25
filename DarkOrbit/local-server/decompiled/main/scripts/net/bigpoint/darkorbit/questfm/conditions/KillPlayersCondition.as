package net.bigpoint.darkorbit.questfm.conditions
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.items.ItemDataProvider;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.display.impl.flash.DOFlashMovieClip;
   
   public class KillPlayersCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _faction_ids:Array = [];
      
      private var _faction_names_list:String = "";
      
      private var _ship_types:Array = [];
      
      private var _ship_names_list:String = "";
      
      private var _avatar_ids:Array = [];
      
      private var _textures:Vector.<BitmapData> = new Vector.<BitmapData>();
      
      public function KillPlayersCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc11_:String = null;
         var _loc12_:Item = null;
         var _loc13_:String = null;
         var _loc2_:Vector.<String> = param1;
         var _loc3_:int = parseInt(_loc2_.shift());
         var _loc4_:Vector.<String> = _loc2_.splice(0,_loc3_);
         var _loc5_:int = parseInt(_loc2_.shift());
         var _loc6_:Vector.<String> = _loc2_.splice(0,_loc5_);
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_.length)
         {
            this._ship_types[_loc7_] = parseInt(_loc4_[_loc7_]);
            _loc12_ = ItemDataProvider.getShipItemByShipId(this._ship_types[_loc7_]);
            if(_loc12_)
            {
               _loc11_ = TextUtils.getTranslationByType(_loc12_.attributes.lootId,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME);
            }
            else
            {
               _loc11_ = InGameCatalog.instance.getShipName(this._ship_types[_loc7_]);
            }
            if(_loc11_)
            {
               this._ship_names_list += ", " + _loc11_;
            }
            _loc13_ = InGameCatalog.instance.getShipIcon(this._ship_types[_loc7_]);
            this._textures.push(getBitmapDataByKey(_loc13_ + "_icon.png"));
            _loc7_++;
         }
         this._ship_names_list = this._ship_names_list.substring(2);
         var _loc8_:Array = InGameCatalog.instance.factions_names;
         var _loc9_:int = 0;
         while(_loc9_ < _loc6_.length)
         {
            this._faction_ids[_loc9_] = parseInt(_loc6_[_loc9_]);
            this._faction_names_list += ", " + _loc8_[this._faction_ids[_loc9_]];
            _loc9_++;
         }
         this._faction_names_list = this._faction_names_list.substring(2);
         var _loc10_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this._ship_types.length > 0)
         {
            _loc10_ += "_ship";
         }
         if(this._faction_ids.length > 0)
         {
            _loc10_ += "_faction";
         }
         if(this._avatar_ids.length > 0)
         {
            _loc10_ += "_avatar";
         }
         if(_target == 0)
         {
            _loc10_ += "_challenge";
         }
         else
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getItem(_loc10_);
         _description = description.replace(/%types%/,this._ship_names_list);
         _description = description.replace(/%faction%/,this._faction_names_list);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
      
      override public function get helpIconsClipCopy() : DisplayObject
      {
         var _loc1_:DOFlashMovieClip = null;
         if(this._ship_types.length == 1)
         {
            return this._textures.length > 0 ? new Bitmap(this._textures[0]) : null;
         }
         if(this._ship_types.length > 1)
         {
            _loc1_ = new DOFlashMovieClip(null,"");
            _loc1_.init(this._textures,1);
            return _loc1_;
         }
         return null;
      }
   }
}

