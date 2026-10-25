package net.bigpoint.darkorbit.mvc.gui.windows.plutus.view.components
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.plutus.model.vo.PlutusRecordVO;
   
   public class PlutusRecordDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _leftBG:Coreponent;
      
      private var _recordIndex:Label;
      
      private var _score:Label;
      
      private var _time:Label;
      
      public function PlutusRecordDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._leftBG = FuiComponentSelectorUtil.selectComponent("left.bg",this) as Coreponent;
         this._recordIndex = FuiComponentSelectorUtil.selectComponent("left.index",this) as Label;
         this._score = FuiComponentSelectorUtil.selectComponent("left.score",this) as Label;
         this._time = FuiComponentSelectorUtil.selectComponent("left.time",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeListeners();
            super.data = param1;
            this.addListeners();
            this.update();
         }
      }
      
      private function addListeners() : void
      {
         var _loc1_:PlutusRecordVO = data as PlutusRecordVO;
         if(_loc1_)
         {
            _loc1_.changed.add(this.update);
         }
      }
      
      private function removeListeners() : void
      {
         var _loc1_:PlutusRecordVO = data as PlutusRecordVO;
         if(_loc1_)
         {
            _loc1_.changed.remove(this.update);
         }
      }
      
      private function update() : void
      {
         var _loc1_:PlutusRecordVO = data as PlutusRecordVO;
         if(_loc1_)
         {
            this._score.text = _loc1_.score.toString();
            this._time.text = TimeFormatter.formatTime(_loc1_.timeInSeconds);
         }
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._leftBG.visible = param1 % 2 != 0;
         this._recordIndex.text = (param1 + 1).toString();
      }
   }
}

