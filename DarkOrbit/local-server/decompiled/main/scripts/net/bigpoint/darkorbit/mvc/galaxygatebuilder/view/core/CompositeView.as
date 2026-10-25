package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core
{
   import flash.events.Event;
   
   public class CompositeView extends ComponentView
   {
      
      private var aChildren:Array;
      
      public function CompositeView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
         this.aChildren = [];
      }
      
      override public function add(param1:ComponentView) : void
      {
         this.aChildren.push(param1);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc2_:ComponentView = null;
         for each(_loc2_ in this.aChildren)
         {
            _loc2_.update(param1);
         }
      }
   }
}

