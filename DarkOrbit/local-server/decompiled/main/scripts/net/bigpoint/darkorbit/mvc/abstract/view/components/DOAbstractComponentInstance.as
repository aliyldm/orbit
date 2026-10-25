package net.bigpoint.darkorbit.mvc.abstract.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   
   public class DOAbstractComponentInstance extends DOAbstractComponentDecorator
   {
      
      public function DOAbstractComponentInstance(param1:SWFFinisher, param2:String)
      {
         _swfFinisher = param1;
         super(_swfFinisher.getEmbeddedObject(param2) as DisplayObjectContainer);
      }
   }
}

