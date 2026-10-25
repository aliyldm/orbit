package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model.WorldBossUIRewardsVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.utils.WorldBossDataAssigner;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class WorldBossUIRewardsItemAssigner extends WorldBossDataAssigner
   {
      
      private var _titleIcon:Button;
      
      private var _containerT:Container;
      
      public function WorldBossUIRewardsItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._titleIcon = FuiComponentSelectorUtil.selectComponent("rewardItems.centerT.icon",this) as Button;
         this._containerT = FuiComponentSelectorUtil.selectComponent("rewardItems.centerT",this) as Container;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:WorldBossUIRewardsVO = null;
         var _loc3_:Bitmap = null;
         _loc2_ = param1 as WorldBossUIRewardsVO;
         if(_loc2_ == null || param1 == null)
         {
            this.visible = false;
            return;
         }
         super.data = _loc2_;
         MovieClipUtils.cleanupDisplayObjectContainer(this._titleIcon);
         if(_loc2_.titleKey)
         {
            _loc3_ = ResourceManager.getBitmap("traininggroundsUI","title_icon");
            _loc3_.width = this._titleIcon.width;
            _loc3_.height = this._titleIcon.height;
            this._titleIcon.addChild(_loc3_);
            this._containerT.visible = true;
            if(_loc2_.titleKey == "title_worldboss_tier_june2026")
            {
               this._titleIcon.tooltipData = BPLocale.getItemInCategory("achievements",_loc2_.titleKey);
            }
            else
            {
               this._titleIcon.tooltipData = BPLocale.getItem(_loc2_.titleKey);
            }
         }
         else
         {
            this._containerT.visible = false;
         }
         this._completion.text = _loc2_.tierLevel;
      }
      
      private function get tiredRewards() : WorldBossUIRewardsVO
      {
         return this.data as WorldBossUIRewardsVO;
      }
      
      public function get VO() : WorldBossUIRewardsVO
      {
         return data as WorldBossUIRewardsVO;
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         _bg.visible = param1 % 2 != 0;
      }
      
      private function setCompletion(param1:BindableInt) : void
      {
         _completion.text = TextFormatter.roundInteger(param1.minValue);
         _completion.text += param1.minValue == param1.maxValue ? "" : " - " + TextFormatter.roundInteger(param1.maxValue);
      }
   }
}

