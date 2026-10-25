package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.view.components
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.darkorbit.com.module.EternalGateRankModule;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class EternalGateRankAssigner extends DefaultItemDataAssigner
   {
      
      private var _rank:Label;
      
      private var _name:Label;
      
      private var _time:Label;
      
      private var _waves:Label;
      
      public function EternalGateRankAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._rank = FuiComponentSelectorUtil.selectComponent("ranking.rank_info.rank",this) as Label;
         this._name = FuiComponentSelectorUtil.selectComponent("ranking.rank_info.name",this) as Label;
         this._time = FuiComponentSelectorUtil.selectComponent("ranking.rank_info.time",this) as Label;
         this._waves = FuiComponentSelectorUtil.selectComponent("ranking.rank_info.waves",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:EternalGateRankModule = null;
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            super.data = param1;
            _loc2_ = param1 as EternalGateRankModule;
            if(_loc2_)
            {
               this.updateRanks();
            }
         }
      }
      
      private function updateRanks() : void
      {
         var _loc1_:EternalGateRankModule = this.rankModule;
         if(_loc1_)
         {
            this._rank.text = TextFormatter.roundInteger(_loc1_.rank);
            this._name.text = _loc1_.name;
            this._time.text = _loc1_.lastUpdateTime;
            this._waves.text = TextFormatter.roundInteger(_loc1_.waves);
         }
      }
      
      private function get rankModule() : EternalGateRankModule
      {
         return data as EternalGateRankModule;
      }
   }
}

