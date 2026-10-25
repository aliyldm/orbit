package net.bigpoint.darkorbit.mvc.common.utils
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.MessageKeyListWildcardCommand;
   import net.bigpoint.darkorbit.com.module.MessageKeyListWildcardModule;
   import net.bigpoint.darkorbit.com.module.MessageLocalizedWildcardCommand;
   import net.bigpoint.darkorbit.com.module.MessageWildcardReplacementModule;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   
   public class TextUtils
   {
      
      private static var itemPostFixes:Object = {};
      
      itemPostFixes[ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE] = "_code";
      itemPostFixes[ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_SHORT] = "_short";
      itemPostFixes[ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME] = "_fullname";
      itemPostFixes[ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_DESCRIPTION] = "_description";
      itemPostFixes[ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_TOOLTIP_DESCRIPTION] = "_tooltip_description";
      itemPostFixes[ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_SOURCE] = "_sources";
      
      public function TextUtils()
      {
         super();
      }
      
      public static function getTooltipText(param1:MessageKeyListWildcardCommand, param2:Boolean = false) : String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MessageKeyListWildcardModule = null;
         var _loc7_:String = null;
         if(param1.commandList.length)
         {
            _loc3_ = "";
            _loc4_ = int(param1.commandList.length);
            _loc5_ = 0;
            while(_loc5_ != _loc4_)
            {
               _loc6_ = param1.commandList[_loc5_];
               _loc7_ = translateMessageKeyListWildcardModule(_loc6_,param2);
               if(_loc7_ == null)
               {
                  return null;
               }
               _loc7_ += _loc5_ != _loc4_ - 1 ? "\n" : "";
               _loc3_ += _loc7_;
               _loc5_++;
            }
            return _loc3_;
         }
         return null;
      }
      
      public static function translateMessageKeyListWildcardModule(param1:MessageKeyListWildcardModule, param2:Boolean = false) : String
      {
         var _loc3_:String = null;
         var _loc4_:MessageWildcardReplacementModule = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param1.baseKey)
         {
            _loc3_ = getTranslationByType(param1.baseKey,param1.baseKeyType.typeValue);
            for each(_loc4_ in param1.wildCardReplacements)
            {
               _loc5_ = getTranslationByType(_loc4_.replacement,_loc4_.replacementType.typeValue);
               _loc3_ = _loc3_.split(_loc4_.wildcard).join(_loc5_);
            }
            if(!param2)
            {
               _loc6_ = getLineColor(param1.textStyle);
               _loc3_ = "<font color=\'" + _loc6_ + "\'>" + _loc3_ + "</font>";
            }
         }
         return _loc3_;
      }
      
      private static function getLineColor(param1:int) : String
      {
         var _loc2_:Number = Number(ItemsControlMenuConstants.TOOLTIPS_STYLES_MAP[param1]);
         return "#" + _loc2_.toString(16);
      }
      
      public static function getTranslationByType(param1:String, param2:int = 0) : String
      {
         var _loc3_:String = "-";
         switch(param2)
         {
            case ReplacementTypeModule.REPLACEMENTTYPE_PLAIN:
               _loc3_ = param1;
               break;
            case ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE:
            case ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_SHORT:
            case ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME:
            case ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_DESCRIPTION:
            case ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_TOOLTIP_DESCRIPTION:
            case ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_SOURCE:
               _loc3_ = BPLocale.getItemInCategory("items",getItemTextKey(param1,param2));
               break;
            case ReplacementTypeModule.REPLACEMENTTYPE_MAP_ID:
               _loc3_ = Map.getMissionMapName(int(param1));
               break;
            case ReplacementTypeModule.REPLACEMENTTYPE_LOCALIZED:
               _loc3_ = BPLocale.getItem(param1);
         }
         return _loc3_;
      }
      
      public static function getItemTextKey(param1:String, param2:int) : String
      {
         if(param1.indexOf("disassemble_disassemble-class") != -1)
         {
            param1 = "disassemble_disassemble-class8";
         }
         if(param1.indexOf("upgrade_upgrade-class") != -1)
         {
            param1 = "upgrade_upgrade-class8";
         }
         return "items_" + param1 + itemPostFixes[param2];
      }
      
      public static function getTooltipTextByMessageLocalizedWildcardCommand(param1:MessageLocalizedWildcardCommand) : String
      {
         var _loc3_:MessageWildcardReplacementModule = null;
         var _loc4_:String = null;
         var _loc2_:String = getTranslationByType(param1.baseKey,param1.baseKeyType.typeValue);
         for each(_loc3_ in param1.wildCardReplacements)
         {
            _loc4_ = getTranslationByType(_loc3_.replacement,_loc3_.replacementType.typeValue);
            _loc2_ = _loc2_.split(_loc3_.wildcard).join(_loc4_);
         }
         return _loc2_;
      }
      
      public static function getRandomLengthText(param1:uint = 1, param2:uint = 500) : String
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc3_:String = "";
         if(param1 > 0)
         {
            if(param2 > param1)
            {
               _loc4_ = param1 + Math.floor(Math.random() * param2);
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc3_ += String.fromCharCode(Math.random() * 70 + 33);
                  _loc5_++;
               }
            }
         }
         return _loc3_;
      }
      
      public static function registerBPLocaleItems(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(param1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1[_loc2_];
               _loc4_ = _loc3_.key;
               _loc5_ = _loc3_.value;
               BPLocale.setItem(_loc4_,_loc5_);
               _loc2_++;
            }
         }
      }
      
      public static function createBPLocaleItemsString(param1:Array) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:String = "";
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = param1[_loc3_];
               _loc5_ = _loc4_.key;
               _loc6_ = _loc4_.value;
               _loc2_ += "<item name=\"" + _loc5_ + "\"><![CDATA[" + _loc6_ + "]]></item>\n";
               _loc3_++;
            }
         }
         return _loc2_;
      }
   }
}

