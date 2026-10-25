package net.bigpoint.darkorbit.mvc.gui.windows.common.model
{
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   
   public class SimpleWindowProxy extends DOAbstractProxy
   {
      
      private var _creationVO:SimpleWindowCreationVO;
      
      public function SimpleWindowProxy(param1:String, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function get creationVO() : SimpleWindowCreationVO
      {
         return this._creationVO;
      }
      
      public function set creationVO(param1:SimpleWindowCreationVO) : void
      {
         this._creationVO = param1;
      }
   }
}

