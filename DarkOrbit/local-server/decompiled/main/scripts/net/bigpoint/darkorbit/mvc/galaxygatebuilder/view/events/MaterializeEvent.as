package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.OutputVO;
   
   public class MaterializeEvent extends Event
   {
      
      public static const MATERIALIZE_NEW_OUTPUT:String = "MaterializeEvent.newOutput";
      
      public static const MATERIALIZE_DUPLICATE_PART:String = "MaterializeEvent.duplicatePart";
      
      public static const MATERIALIZE_ENABLE_ENERGY_BUTTON:String = "MaterializeEvent.enableEnergyButton";
      
      public static const MATERIALIZE_MULTIPLE_PART_OUTPUT:String = "MaterializeEvent.multiplePartOutput";
      
      public static const MATERIALIZE_SHOW_MESSAGE:String = "MaterializeEvent.showMessage";
      
      public var output:OutputVO;
      
      public var showMessage:Boolean;
      
      public var fromCache:Boolean;
      
      public function MaterializeEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

