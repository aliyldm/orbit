package net.bigpoint.darkorbit.mvc.traininggrounds.view.list
{
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   
   public class TraininggroundsStatsListItemDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _dataColumn:Label;
      
      private var _winnerColumn:Label;
      
      private var _loserColumn:Label;
      
      public function TraininggroundsStatsListItemDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._dataColumn = getChildByName("dataColumn") as Label;
         this._winnerColumn = getChildByName("winnerColumn") as Label;
         this._loserColumn = getChildByName("loserColumn") as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:Vector.<String> = param1 as Vector.<String>;
         this._dataColumn.text = _loc2_[0];
         this._winnerColumn.text = _loc2_[1];
         this._loserColumn.text = _loc2_[2];
      }
   }
}

