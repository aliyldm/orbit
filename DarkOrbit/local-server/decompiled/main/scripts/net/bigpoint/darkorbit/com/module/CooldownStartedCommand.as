package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CooldownStartedCommand implements IModule
   {
      
      private static var _instance:CooldownStartedCommand;
      
      public var type:CooldownTypeModule;
      
      public var seconds:int = 0;
      
      public function CooldownStartedCommand(param1:CooldownTypeModule = null, param2:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.type = new CooldownTypeModule();
         }
         else
         {
            this.type = param1;
         }
         this.seconds = param2;
      }
      
      public static function get instance() : CooldownStartedCommand
      {
         return _instance || (_instance = new CooldownStartedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 93;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = CooldownTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.type)
         {
            this.type.read(param1);
         }
         this.seconds = param1.readInt();
         this.seconds = this.seconds >>> 16 % 32 | this.seconds << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(93);
         if(null != this.type)
         {
            this.type.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.seconds << 16 % 32 | this.seconds >>> 32 - 16 % 32);
      }
   }
}

