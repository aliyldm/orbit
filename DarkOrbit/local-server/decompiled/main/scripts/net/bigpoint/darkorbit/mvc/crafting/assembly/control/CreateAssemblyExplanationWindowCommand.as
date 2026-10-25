package net.bigpoint.darkorbit.mvc.crafting.assembly.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.AssemblyExplanationWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateAssemblyExplanationWindowCommand extends DOAbstractSimpleCommand
   {
      
      public function CreateAssemblyExplanationWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SimpleWindow = null;
         var _loc3_:String = null;
         super.execute(param1);
         _loc2_ = guiManager.getWindow(GuiConstants.ASSEMBLY_EXPLANATION_WINDOW);
         if(_loc2_ == null)
         {
            _loc2_ = guiManager.createWindow(GuiConstants.ASSEMBLY_EXPLANATION_WINDOW) as SimpleWindow;
            _loc3_ = param1.getBody() as String;
            this.buildWindowContent(_loc2_,_loc3_);
         }
         else
         {
            this.finalize(_loc2_);
         }
      }
      
      private function finalize(param1:SimpleWindow) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         param1.maximize(false,true);
         var _loc2_:SimpleWindow = guiManager.getWindow(GuiConstants.ASSEMBLY_WINDOW) as SimpleWindow;
         if(_loc2_)
         {
            if(_loc2_.maximized)
            {
               _loc3_ = screenManager.stageSize.x >> 1;
               _loc4_ = _loc2_.x + (_loc2_.width >> 1);
               if(_loc4_ > _loc3_)
               {
                  param1.x = _loc2_.x - _loc2_.width;
               }
               else
               {
                  param1.x = _loc2_.x + _loc2_.width;
               }
               param1.y = _loc2_.y;
            }
            else
            {
               this.centerHorizontally(param1);
            }
         }
         else
         {
            this.centerHorizontally(param1);
         }
      }
      
      private function centerHorizontally(param1:SimpleWindow) : void
      {
         param1.x = screenManager.stageSize.x - param1.width >> 1;
         param1.y = 100;
      }
      
      private function buildWindowContent(param1:SimpleWindow, param2:String) : void
      {
         var _loc3_:SimpleContainer = param1.getContainer(0);
         var _loc4_:DisplayObjectContainer = new Sprite();
         _loc3_.addElement(_loc4_);
         UISystem.getInstance().loadAndBuildWithResKey(param2,_loc4_,this.handleBuildComplete,[param1,_loc4_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         if(!facade.hasCommand(AssemblyNotifications.CLOSE_EXPLANATION_WINDOW))
         {
            registerCommand(AssemblyNotifications.CLOSE_EXPLANATION_WINDOW,CloseAssemblyExplanationWindowCommand);
         }
         if(!facade.hasMediator(AssemblyExplanationWindowMediator.NAME))
         {
            registerMediator(new AssemblyExplanationWindowMediator(param1,param2.getChildAt(0) as Container));
         }
         this.finalize(param1);
      }
   }
}

