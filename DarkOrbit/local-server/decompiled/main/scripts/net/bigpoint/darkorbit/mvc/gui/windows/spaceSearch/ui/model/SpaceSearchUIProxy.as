package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model
{
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class SpaceSearchUIProxy extends SimpleWindowProxy
   {
      
      public function SpaceSearchUIProxy(param1:String)
      {
         super(param1,new SpaceSearchUIData());
      }
      
      public static function getOrCreateProxy(param1:IFacade) : SpaceSearchUIProxy
      {
         var _loc2_:SpaceSearchUIProxy = param1.retrieveProxy(GuiConstants.SPACE_SEARCH) as SpaceSearchUIProxy;
         if(!_loc2_)
         {
            _loc2_ = new SpaceSearchUIProxy(GuiConstants.SPACE_SEARCH);
            param1.registerProxy(_loc2_);
         }
         return _loc2_;
      }
      
      public function get viewData() : SpaceSearchUIData
      {
         return this.data as SpaceSearchUIData;
      }
   }
}

