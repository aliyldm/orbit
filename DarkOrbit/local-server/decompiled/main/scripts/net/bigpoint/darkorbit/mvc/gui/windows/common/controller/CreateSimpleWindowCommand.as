package net.bigpoint.darkorbit.mvc.gui.windows.common.controller
{
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   
   public class CreateSimpleWindowCommand extends AbstractSimpleWindowCreateCommand
   {
      
      public function CreateSimpleWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:String = null;
         var _loc4_:Class = null;
         var _loc5_:IProxy = null;
         var _loc6_:SimpleWindowProxy = null;
         var _loc7_:IWindow = null;
         var _loc8_:Class = null;
         var _loc9_:SimpleWindowMediator = null;
         var _loc2_:SimpleWindowCreationVO = param1.getBody() as SimpleWindowCreationVO;
         if(_loc2_)
         {
            if(_loc2_.windowID)
            {
               if(_loc2_.commandMap)
               {
                  for(_loc3_ in _loc2_.commandMap)
                  {
                     if(!hasCommand(_loc3_))
                     {
                        _loc4_ = _loc2_.commandMap[_loc3_];
                        registerCommand(_loc3_,_loc4_);
                     }
                  }
               }
               if(_loc2_.proxyClass)
               {
                  _loc5_ = null;
                  if(!hasProxy(_loc2_.windowID))
                  {
                     _loc5_ = new _loc2_.proxyClass(_loc2_.windowID);
                     registerProxy(_loc5_);
                  }
                  else
                  {
                     _loc5_ = retrieveProxy(_loc2_.windowID);
                  }
                  _loc6_ = _loc5_ as SimpleWindowProxy;
                  if(_loc6_)
                  {
                     _loc6_.creationVO = _loc2_;
                  }
               }
               if(_loc2_.mediatorClass)
               {
                  if(!hasMediator(_loc2_.windowID))
                  {
                     _loc7_ = createWindow(_loc2_);
                     if(!_loc7_)
                     {
                        throw new Error("Could not create a window instance with the ID = " + _loc2_.windowID);
                     }
                     _loc8_ = _loc2_.mediatorClass;
                     _loc9_ = new _loc8_(_loc2_.windowID,_loc7_);
                     registerMediator(_loc9_);
                     if(_loc2_.uiResoureKey)
                     {
                        _loc9_.loadAndBuildContent(_loc2_.uiResoureKey);
                     }
                  }
               }
            }
         }
      }
   }
}

