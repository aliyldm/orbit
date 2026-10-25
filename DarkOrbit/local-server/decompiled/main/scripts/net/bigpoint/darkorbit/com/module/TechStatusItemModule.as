package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TechStatusItemModule implements IModule
   {
      
      private static var _instance:TechStatusItemModule;
      
      public var techStatus:StatusModule;
      
      public var amount:int = 0;
      
      public var seconds:int = 0;
      
      public function TechStatusItemModule(param1:StatusModule = null, param2:int = 0, param3:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.techStatus = new StatusModule();
         }
         else
         {
            this.techStatus = param1;
         }
         this.amount = param2;
         this.seconds = param3;
      }
      
      public static function get instance() : TechStatusItemModule
      {
         return _instance || (_instance = new TechStatusItemModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 71;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.techStatus = StatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.techStatus)
         {
            this.techStatus.read(param1);
         }
         this.amount = param1.readInt();
         this.amount = this.amount << 14 % 32 | this.amount >>> 32 - 14 % 32;
         this.seconds = param1.readInt();
         this.seconds = this.seconds >>> 3 % 32 | this.seconds << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(71);
         if(null != this.techStatus)
         {
            this.techStatus.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.amount >>> 14 % 32 | this.amount << 32 - 14 % 32);
         param1.writeInt(this.seconds << 3 % 32 | this.seconds >>> 32 - 3 % 32);
      }
   }
}

