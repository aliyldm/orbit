package net.bigpoint.darkorbit.questfm.conditions
{
   import flash.display.DisplayObject;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.questfm.icon.ItemClip;
   
   public class CollectLootCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _lootId:String;
      
      public function CollectLootCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         this._lootId = param1[0] ? param1[0] : "";
         _description = _description.replace(/%TYPE%/,TextUtils.getTranslationByType(this._lootId,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME));
         _target_plain = "/" + _target;
      }
      
      override public function get currentVerbose() : String
      {
         return _current.toString();
      }
      
      override public function get helpIconsClipCopy() : DisplayObject
      {
         return new ItemClip(this._lootId);
      }
   }
}

