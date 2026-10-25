package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TechDeactivationCommand implements IModule
   {
      
      private static var _instance:TechDeactivationCommand;
      
      public var techType:TechTypeModule;
      
      public var userId:int = 0;
      
      public function TechDeactivationCommand(param1:TechTypeModule = null, param2:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.techType = new TechTypeModule();
         }
         else
         {
            this.techType = param1;
         }
         this.userId = param2;
      }
      
      public static function get instance() : TechDeactivationCommand
      {
         return _instance || (_instance = new TechDeactivationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 74;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.techType = TechTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.techType)
         {
            this.techType.read(param1);
         }
         this.userId = param1.readInt();
         this.userId = this.userId << 5 % 32 | this.userId >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(74);
         if(null != this.techType)
         {
            this.techType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.userId >>> 5 % 32 | this.userId << 32 - 5 % 32);
      }
   }
}

