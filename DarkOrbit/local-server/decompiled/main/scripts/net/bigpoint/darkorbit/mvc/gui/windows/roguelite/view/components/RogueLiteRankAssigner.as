package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import com.bigpoint.utils.TextFormatter;
   import flash.globalization.DateTimeFormatter;
   import flash.globalization.LocaleID;
   import net.bigpoint.darkorbit.com.module.RankModule;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class RogueLiteRankAssigner extends DefaultItemDataAssigner
   {
      
      private var _rank:Label;
      
      private var _name:Label;
      
      private var _time:Label;
      
      private var _score:Label;
      
      public function RogueLiteRankAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._rank = FuiComponentSelectorUtil.selectComponent("rank_info.rank",this) as Label;
         this._name = FuiComponentSelectorUtil.selectComponent("rank_info.name",this) as Label;
         this._time = FuiComponentSelectorUtil.selectComponent("rank_info.time",this) as Label;
         this._score = FuiComponentSelectorUtil.selectComponent("rank_info.score",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:RankModule = param1 as RankModule;
         if(!_loc2_)
         {
            visible = false;
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         this.updateRankInfo();
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      public function get module() : RankModule
      {
         return data as RankModule;
      }
      
      private function updateRankInfo() : void
      {
         var _loc1_:Date = null;
         var _loc2_:DateTimeFormatter = null;
         if(!this.module)
         {
            return;
         }
         this._name.text = this.module.name;
         if(this.module.rank != 0)
         {
            this._rank.text = TextFormatter.roundInteger(this.module.rank);
            _loc1_ = new Date(this.module.lastUpdateTime);
            _loc2_ = new DateTimeFormatter(LocaleID.DEFAULT);
            _loc2_.setDateTimePattern("dd/MM HH:mm");
            this._time.text = _loc2_.format(_loc1_);
            this._score.text = TextFormatter.roundInteger(this.module.points);
         }
         else
         {
            this._rank.text = "-";
            this._time.text = "-";
            this._score.text = "-";
         }
      }
   }
}

