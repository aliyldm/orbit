package net.bigpoint.darkorbit.questfm.conditions
{
   import com.adobe.utils.StringUtil;
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
   
   public class DamageEnemyPlayersCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var factionIDs:Array = [];
      
      private var factionNamesList:String = "";
      
      private var _shipTypes:Array = [];
      
      private var shipNamesList:String = "";
      
      private var avatarIDs:Array = [];
      
      private var _textures:Vector.<BitmapData> = new Vector.<BitmapData>();
      
      public function DamageEnemyPlayersCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc16_:String = null;
         var _loc17_:Item = null;
         var _loc2_:Vector.<String> = param1;
         var _loc3_:int = int(_loc2_.shift());
         var _loc4_:Vector.<String> = _loc2_.splice(0,_loc3_);
         var _loc5_:int = int(_loc2_.shift());
         var _loc6_:Vector.<String> = _loc2_.splice(0,_loc5_);
         var _loc7_:int = parseInt(_loc2_.shift());
         var _loc8_:Vector.<String> = _loc2_.splice(0,_loc7_);
         var _loc9_:int = int(_loc2_.shift());
         var _loc10_:Vector.<String> = _loc2_.splice(0,_loc9_);
         var _loc11_:int = 0;
         while(_loc11_ < _loc4_.length)
         {
            this._shipTypes[_loc11_] = int(_loc4_[_loc11_]);
            _loc17_ = ItemDataProvider.getShipItemByShipId(this._shipTypes[_loc11_]);
            if(_loc17_)
            {
               _loc16_ = TextUtils.getTranslationByType(_loc17_.attributes.lootId,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME);
            }
            else
            {
               _loc16_ = InGameCatalog.instance.getShipName(this._shipTypes[_loc11_]);
            }
            if(_loc16_)
            {
               this.shipNamesList += ", " + _loc16_;
            }
            this._textures.push(getBitmapDataByKey(InGameCatalog.instance.getShipIcon(this._shipTypes[_loc11_]) + "_icon.png"));
            _loc11_++;
         }
         this.shipNamesList = this.shipNamesList.substring(2);
         var _loc12_:Array = InGameCatalog.instance.factions_names;
         var _loc13_:int = 0;
         while(_loc13_ < _loc6_.length)
         {
            this.factionIDs[_loc13_] = int(_loc6_[_loc13_]);
            this.factionNamesList += ", " + _loc12_[this.factionIDs[_loc13_]];
            _loc13_++;
         }
         this.factionNamesList = this.factionNamesList.substring(2);
         var _loc14_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this._shipTypes.length == 0 && this.factionIDs.length == 0 && this.avatarIDs.length == 0)
         {
            _loc14_ += "_any";
         }
         else
         {
            if(this._shipTypes.length > 0)
            {
               _loc14_ += "_ships";
            }
            if(this.factionIDs.length > 0)
            {
               if(this.factionIDs[0] == InGameCatalog.FACTION_OTHER)
               {
                  _loc14_ += "_enemyfactions";
               }
               else
               {
                  _loc14_ += "_factions";
               }
            }
            if(this.avatarIDs.length > 0)
            {
               _loc14_ += "_avatar";
            }
         }
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
         var _loc15_:int = _loc10_.length > 0 ? int(_loc10_[0]) : 0;
         _loc14_ += "_" + InGameCatalog.instance.damage_types[_loc15_];
         if(StringUtil.endsWith(_loc14_,"_any_any"))
         {
            _loc14_ = _loc14_.replace("_any_any","_any");
         }
         _description = BPLocale.getItem(_loc14_);
         _description = description.replace(/%types%/,this.shipNamesList);
         _description = description.replace(/%faction%/,this.factionNamesList);
         if(this._shipTypes.length > 0)
         {
            _helpIconData = getBitmapDataByKey(InGameCatalog.instance.getShipIcon(this._shipTypes[0]) + "_icon.png");
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
      
      override public function get helpIconsClipCopy() : DisplayObject
      {
         var _loc1_:DOFlashMovieClip = null;
         if(this._shipTypes.length == 1)
         {
            return this._textures.length > 0 ? new Bitmap(this._textures[0]) : null;
         }
         if(this._shipTypes.length > 1)
         {
            _loc1_ = new DOFlashMovieClip(null,"");
            _loc1_.init(this._textures,1);
            return _loc1_;
         }
         return null;
      }
   }
}

