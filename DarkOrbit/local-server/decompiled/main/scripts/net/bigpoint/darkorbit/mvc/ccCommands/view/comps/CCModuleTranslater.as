package net.bigpoint.darkorbit.mvc.ccCommands.view.comps
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.CCBooleanValueModule;
   import net.bigpoint.darkorbit.com.module.CCDateValueModule;
   import net.bigpoint.darkorbit.com.module.CCIntValueModule;
   import net.bigpoint.darkorbit.com.module.CCItemValueModule;
   import net.bigpoint.darkorbit.com.module.CCQuestValueModule;
   import net.bigpoint.darkorbit.com.module.CCStringValueModule;
   import net.bigpoint.darkorbit.com.module.CCValueModule;
   import net.bigpoint.darkorbit.delete_in_eic.Constants;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.questfm.QuestLocale;
   import net.bigpoint.darkorbit.utils.BPLocaleUtils;
   
   public class CCModuleTranslater
   {
      
      private static const ID_TO_TRANSLATION:Object = {};
      
      private static const ID_TO_HISTORY_STRING:Object = {};
      
      private static const ID_TO_FILTER:Object = {};
      
      ID_TO_TRANSLATION[CCQuestValueModule.instance.getLibcomModuleId()] = translateCCQuestValueModule;
      ID_TO_TRANSLATION[CCItemValueModule.instance.getLibcomModuleId()] = translateCCItemValueModule;
      ID_TO_HISTORY_STRING[CCBooleanValueModule.instance.getLibcomModuleId()] = toBoolString;
      ID_TO_HISTORY_STRING[CCIntValueModule.instance.getLibcomModuleId()] = toIntSting;
      ID_TO_HISTORY_STRING[CCStringValueModule.instance.getLibcomModuleId()] = toStringString;
      ID_TO_HISTORY_STRING[CCItemValueModule.instance.getLibcomModuleId()] = toItemString;
      ID_TO_HISTORY_STRING[CCQuestValueModule.instance.getLibcomModuleId()] = translateCCQuestValueModule;
      ID_TO_HISTORY_STRING[CCDateValueModule.instance.getLibcomModuleId()] = toDateString;
      ID_TO_FILTER[CCItemValueModule.instance.getLibcomModuleId()] = filterItemModule;
      
      public function CCModuleTranslater()
      {
         super();
      }
      
      private static function translateCCItemValueModule(param1:CCItemValueModule) : String
      {
         var _loc2_:String = ItemVO.PREFIX_BPLOCAL_ITEMCATEGORY + param1.lootId + ItemVO.POST_ADDENDUM_FULLNAME;
         var _loc3_:String = BPLocaleUtils.hasTranslation(_loc2_,Constants.BPLOCAL_CATEGORY__ITEMS) ? BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,_loc2_) : param1.name;
         _loc2_ = ItemVO.PREFIX_BPLOCAL_ITEMCATEGORY + param1.lootId + ItemVO.POST_ADDENDUM_CODE;
         var _loc4_:String = BPLocaleUtils.hasTranslation(_loc2_,Constants.BPLOCAL_CATEGORY__ITEMS) ? BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,_loc2_) : param1.name;
         return param1.lootId + " [" + _loc3_ + "]";
      }
      
      public static function moduleToString(param1:CCValueModule) : String
      {
         var _loc2_:Function = ID_TO_TRANSLATION[param1.getLibcomModuleId()];
         return _loc2_ != null ? _loc2_(param1) : param1.name;
      }
      
      private static function translateCCQuestValueModule(param1:CCQuestValueModule) : String
      {
         return param1.name + ": " + QuestLocale.getTitleEx(param1.value,"") + ": " + param1.value;
      }
      
      public static function toHistoryString(param1:CCValueModule) : String
      {
         var _loc2_:Function = ID_TO_HISTORY_STRING[param1.getLibcomModuleId()];
         if(_loc2_ != null)
         {
            return _loc2_(param1);
         }
         return param1.name;
      }
      
      private static function toDateString(param1:CCDateValueModule) : String
      {
         return param1.name + ": " + new Date(param1.value).toDateString();
      }
      
      private static function toItemString(param1:CCItemValueModule) : String
      {
         return param1.name + ": " + param1.lootId;
      }
      
      private static function toStringString(param1:CCStringValueModule) : String
      {
         return param1.name + ": " + param1.value;
      }
      
      private static function toIntSting(param1:CCIntValueModule) : String
      {
         return param1.name + ": " + param1.value;
      }
      
      private static function toBoolString(param1:CCBooleanValueModule) : String
      {
         return param1.name + ": " + param1.value;
      }
      
      public static function filter(param1:String, param2:CCValueModule) : Boolean
      {
         var _loc3_:String = null;
         if(ID_TO_FILTER[param2.getLibcomModuleId()])
         {
            return ID_TO_FILTER[param2.getLibcomModuleId()](param1,param2);
         }
         _loc3_ = CCModuleTranslater.moduleToString(param2);
         return _loc3_.toLowerCase().indexOf(param1.toLowerCase()) != -1;
      }
      
      private static function filterItemModule(param1:String, param2:CCItemValueModule) : Boolean
      {
         var _loc3_:String = translateCCItemValueModule(param2);
         var _loc4_:String = param1.toLowerCase();
         return _loc3_.toLowerCase().indexOf(_loc4_) != -1 || param2.lootId.indexOf(_loc4_) != -1 || param2.name.toLowerCase().indexOf(_loc4_) != -1;
      }
   }
}

