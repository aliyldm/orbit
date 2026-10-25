package net.bigpoint.darkorbit.mvc.refractionzoneWindow.model
{
   import net.bigpoint.darkorbit.com.module.RzoneStatusCommand;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo.RZoneModel;
   
   public class RZoneStatusProxy extends DOAbstractProxy
   {
      
      public static var NAME:String = "RZoneStatusProxy";
      
      public function RZoneStatusProxy()
      {
         super(NAME,new RZoneModel());
      }
      
      private function get model() : RZoneModel
      {
         return data as RZoneModel;
      }
      
      public function update(param1:RzoneStatusCommand) : void
      {
         this.model.update(param1);
      }
   }
}

