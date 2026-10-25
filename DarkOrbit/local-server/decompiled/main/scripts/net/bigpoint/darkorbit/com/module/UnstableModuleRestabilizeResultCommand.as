package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UnstableModuleRestabilizeResultCommand implements IModule
   {
      
      private static var _instance:UnstableModuleRestabilizeResultCommand;
      
      public var itemId:Number = 0;
      
      public var newModule:UnstableModuleModule;
      
      public var oldModule:UnstableModuleModule;
      
      public var success:Boolean = false;
      
      public function UnstableModuleRestabilizeResultCommand(param1:Boolean = false, param2:Number = 0, param3:UnstableModuleModule = null, param4:UnstableModuleModule = null)
      {
         super();
         this.itemId = param2;
         if(param4 == null)
         {
            this.newModule = new UnstableModuleModule();
         }
         else
         {
            this.newModule = param4;
         }
         if(param3 == null)
         {
            this.oldModule = new UnstableModuleModule();
         }
         else
         {
            this.oldModule = param3;
         }
         this.success = param1;
      }
      
      public static function get instance() : UnstableModuleRestabilizeResultCommand
      {
         return _instance || (_instance = new UnstableModuleRestabilizeResultCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17488;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemId = param1.readDouble();
         this.newModule = UnstableModuleModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.newModule)
         {
            this.newModule.read(param1);
         }
         this.oldModule = UnstableModuleModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.oldModule)
         {
            this.oldModule.read(param1);
         }
         this.success = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17488);
         param1.writeDouble(this.itemId);
         if(null != this.newModule)
         {
            this.newModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.oldModule)
         {
            this.oldModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.success);
      }
   }
}

