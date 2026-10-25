package net.bigpoint.darkorbit.mvc.traininggrounds.view.list
{
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   
   public class TraininggroundsRewardsListItemDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _rewardColumn:Label;
      
      private var _amountColumn:Label;
      
      public function TraininggroundsRewardsListItemDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._rewardColumn = getChildByName("rewardColumn") as Label;
         this._amountColumn = getChildByName("amountColumn") as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:Vector.<String> = param1 as Vector.<String>;
         if(_loc2_)
         {
            this._rewardColumn.text = _loc2_[0];
            this._amountColumn.text = _loc2_[1];
            this.visible = true;
         }
         else
         {
            this._rewardColumn.text = "";
            this._amountColumn.text = "";
            this.visible = false;
         }
      }
   }
}

