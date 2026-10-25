package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.worldboss
{
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class RankingsUIWorldBossRowAssigner extends DefaultItemDataAssigner
   {
      
      private var _bg:Coreponent;
      
      private var _rank:Label;
      
      private var _name:Label;
      
      private var _score:Label;
      
      private var _time:Label;
      
      public function RankingsUIWorldBossRowAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg = FuiComponentSelectorUtil.selectComponent("row.bg",this) as Coreponent;
         this._rank = FuiComponentSelectorUtil.selectComponent("row.rank",this) as Label;
         this._name = FuiComponentSelectorUtil.selectComponent("row.name",this) as Label;
         this._score = FuiComponentSelectorUtil.selectComponent("row.score",this) as Label;
         this._time = FuiComponentSelectorUtil.selectComponent("row.time",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         if(!param1)
         {
            visible = false;
            return;
         }
         this.removeListeners();
         super.data = param1;
         this.addListeners();
         this.updateRankInfo();
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      public function get rank() : Vector.<String>
      {
         return data as Vector.<String>;
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._bg.visible = param1 % 2 != 0;
      }
      
      private function updateRankInfo() : void
      {
         if(this.rank == null || this.rank.length != 4)
         {
            return;
         }
         this._rank.text = this.rank[0] == "" ? "-" : this.rank[0];
         this._name.text = this.rank[1] == "" ? "-" : this.rank[1];
         this._score.text = this.rank[2] == "" ? "-" : this.rank[2];
         this._time.text = this.rank[3] == "" ? "-" : this.rank[3];
      }
   }
}

