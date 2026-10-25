package net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.view.components
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthRankModule;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class FrozenLabyrinthRankAssigner extends DefaultItemDataAssigner
   {
      
      private var _rank:Label;
      
      private var _name:Label;
      
      private var _time:Label;
      
      private var _kills:Label;
      
      public function FrozenLabyrinthRankAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._rank = FuiComponentSelectorUtil.selectComponent("rank.rank_info.rank",this) as Label;
         this._name = FuiComponentSelectorUtil.selectComponent("rank.rank_info.name",this) as Label;
         this._time = FuiComponentSelectorUtil.selectComponent("rank.rank_info.time",this) as Label;
         this._kills = FuiComponentSelectorUtil.selectComponent("rank.rank_info.kills",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:FrozenLabyrinthRankModule = null;
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            super.data = param1;
            _loc2_ = param1 as FrozenLabyrinthRankModule;
            if(_loc2_)
            {
               this.updateRanks();
            }
         }
      }
      
      private function updateRanks() : void
      {
         var _loc1_:FrozenLabyrinthRankModule = this.rankModule;
         if(_loc1_)
         {
            this._rank.text = TextFormatter.roundInteger(_loc1_.rank);
            this._name.text = _loc1_.name;
            this._time.text = _loc1_.lastKillTime;
            this._kills.text = TextFormatter.roundInteger(_loc1_.kills);
         }
      }
      
      private function get rankModule() : FrozenLabyrinthRankModule
      {
         return data as FrozenLabyrinthRankModule;
      }
   }
}

