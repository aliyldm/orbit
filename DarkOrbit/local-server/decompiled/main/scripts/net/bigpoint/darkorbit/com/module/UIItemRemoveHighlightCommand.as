package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIItemRemoveHighlightCommand implements IModule
   {
      
      private static var _instance:UIItemRemoveHighlightCommand;
      
      public var itemId:String = "";
      
      public var itemSource:UiItemSourceModule;
      
      public var highlightType:HighlightTypeModule;
      
      public function UIItemRemoveHighlightCommand(param1:UiItemSourceModule = null, param2:String = "", param3:HighlightTypeModule = null)
      {
         super();
         this.itemId = param2;
         if(param1 == null)
         {
            this.itemSource = new UiItemSourceModule();
         }
         else
         {
            this.itemSource = param1;
         }
         if(param3 == null)
         {
            this.highlightType = new HighlightTypeModule();
         }
         else
         {
            this.highlightType = param3;
         }
      }
      
      public static function get instance() : UIItemRemoveHighlightCommand
      {
         return _instance || (_instance = new UIItemRemoveHighlightCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19062;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemId = param1.readUTF();
         this.itemSource = UiItemSourceModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.itemSource)
         {
            this.itemSource.read(param1);
         }
         this.highlightType = HighlightTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.highlightType)
         {
            this.highlightType.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(19062);
         param1.writeUTF(this.itemId);
         if(null != this.itemSource)
         {
            this.itemSource.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.highlightType)
         {
            this.highlightType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

