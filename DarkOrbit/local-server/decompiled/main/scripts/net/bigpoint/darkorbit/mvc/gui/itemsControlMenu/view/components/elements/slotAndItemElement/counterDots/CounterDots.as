package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.counterDots
{
   import com.bigpoint.utils.ui.panels.HPanelDecorator;
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentDecorator;
   
   public class CounterDots extends DOAbstractComponentDecorator
   {
      
      private static const DOTS_IN_ROW:int = 5;
      
      private static const FIRST_ROW:String = "firstRow";
      
      private static const SECOND_ROW:String = "secondRow";
      
      public var firsRow:HPanelDecorator;
      
      public var secondRow:HPanelDecorator;
      
      private var _dotColor:Number = 16777215;
      
      public function CounterDots(param1:DisplayObjectContainer, param2:SWFFinisher)
      {
         super(param1,param2);
      }
      
      override public function decorate() : void
      {
         addViewChild(this.firsRow = new HPanelDecorator(getSpriteChild(FIRST_ROW)));
         addViewChild(this.secondRow = new HPanelDecorator(getSpriteChild(SECOND_ROW)));
      }
      
      public function setProgress(param1:int, param2:int, param3:Number, param4:Boolean = true) : void
      {
         this.firsRow.removeItems();
         this.secondRow.removeItems();
         this._dotColor = param3;
         this.showDots(this.firsRow,Math.min(param1,DOTS_IN_ROW),Math.min(param2,DOTS_IN_ROW));
         if(param2 > 5)
         {
            this.showDots(this.secondRow,Math.max(0,param1 - DOTS_IN_ROW),Math.max(0,param2 - DOTS_IN_ROW));
         }
         if(param4)
         {
            visible = true;
            alpha = 1;
         }
         this.updateLayout();
      }
      
      private function showDots(param1:HPanelDecorator, param2:int, param3:Number) : void
      {
         var _loc5_:Dot = null;
         param1.removeItems();
         var _loc4_:int = 0;
         while(_loc4_ != param3)
         {
            _loc5_ = new Dot(_swfFinisher);
            _loc5_.setData(_loc4_ < param2,this._dotColor);
            param1.addItem(_loc5_,1,0);
            _loc4_++;
         }
      }
      
      override public function updateLayout() : void
      {
         this.firsRow.x = width - this.firsRow.width >> 1;
         this.secondRow.x = width - this.secondRow.width >> 1;
      }
   }
}

