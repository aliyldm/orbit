package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.bindables.BindableInt;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.model.WorldBossUIProgressVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model.WorldBossUIRewardsVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.utils.WorldBossDataAssigner;
   
   public class WorldBossUIProgressItemAssigner extends WorldBossDataAssigner
   {
      
      private var _damage:Label;
      
      private var _claim:Label;
      
      public function WorldBossUIProgressItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._claim = FuiComponentSelectorUtil.selectComponent("claim",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:WorldBossUIProgressVO = param1 as WorldBossUIProgressVO;
         if(_loc2_ == null || param1 == null)
         {
            this.visible = false;
            return;
         }
         super.data = _loc2_;
         _completion.text = _loc2_.damage.toString();
         this._claim.text = _loc2_.claim + "/" + _loc2_.claimLimit;
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

