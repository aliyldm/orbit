package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model
{
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class SpaceSearchRedDotProxy extends SimpleWindowProxy
   {
      
      public function SpaceSearchRedDotProxy(param1:String)
      {
         super(param1,new SpaceSearchRedDotData());
      }
      
      public static function getOrCreateProxy(param1:IFacade) : SpaceSearchRedDotProxy
      {
         var _loc2_:SpaceSearchRedDotProxy = param1.retrieveProxy(GuiConstants.SPACE_SEARCH_RED_DOT) as SpaceSearchRedDotProxy;
         if(!_loc2_)
         {
            _loc2_ = new SpaceSearchRedDotProxy(GuiConstants.SPACE_SEARCH_RED_DOT);
            param1.registerProxy(_loc2_);
         }
         return _loc2_;
      }
      
      public function get viewData() : SpaceSearchRedDotData
      {
         return this.data as SpaceSearchRedDotData;
      }
   }
}

