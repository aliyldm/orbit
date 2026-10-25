package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TechActivationCommand implements IModule
   {
      
      private static var _instance:TechActivationCommand;
      
      public var techType:TechTypeModule;
      
      public var userId:int = 0;
      
      public function TechActivationCommand(param1:TechTypeModule = null, param2:int = 0)
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
      
      public static function get instance() : TechActivationCommand
      {
         return _instance || (_instance = new TechActivationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 73;
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
         this.userId = this.userId << 16 % 32 | this.userId >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(73);
         if(null != this.techType)
         {
            this.techType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.userId >>> 16 % 32 | this.userId << 32 - 16 % 32);
      }
   }
}

