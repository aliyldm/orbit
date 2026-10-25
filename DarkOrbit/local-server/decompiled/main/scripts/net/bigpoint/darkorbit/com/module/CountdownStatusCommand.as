package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CountdownStatusCommand implements IModule
   {
      
      private static var _instance:CountdownStatusCommand;
      
      public var type:CountdownStatusTypeModule;
      
      public var currentAmount:int = 0;
      
      public var maxAmount:int = 0;
      
      public function CountdownStatusCommand(param1:CountdownStatusTypeModule = null, param2:int = 0, param3:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.type = new CountdownStatusTypeModule();
         }
         else
         {
            this.type = param1;
         }
         this.currentAmount = param2;
         this.maxAmount = param3;
      }
      
      public static function get instance() : CountdownStatusCommand
      {
         return _instance || (_instance = new CountdownStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4713;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = CountdownStatusTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.type)
         {
            this.type.read(param1);
         }
         this.currentAmount = param1.readInt();
         this.currentAmount = this.currentAmount >>> 9 % 32 | this.currentAmount << 32 - 9 % 32;
         this.maxAmount = param1.readInt();
         this.maxAmount = this.maxAmount << 13 % 32 | this.maxAmount >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4713);
         if(null != this.type)
         {
            this.type.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.currentAmount << 9 % 32 | this.currentAmount >>> 32 - 9 % 32);
         param1.writeInt(this.maxAmount >>> 13 % 32 | this.maxAmount << 32 - 13 % 32);
      }
   }
}

