package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMDiscountInfoCommand implements IModule
   {
      
      private static var _instance:LMDiscountInfoCommand;
      
      public static const DISCOUNTTYPE_LOOT:int = 0;
      
      public static const DISCOUNTTYPE_REWARD:int = 1;
      
      public static const DISCOUNTTYPE__MAX:int = 2;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var discountType:int = 0;
      
      public var percentage:Number = 0;
      
      public function LMDiscountInfoCommand(param1:LogMessengerPriorityModule = null, param2:int = 0, param3:Number = 0)
      {
         super();
         if(param1 == null)
         {
            this.priorityMode = new LogMessengerPriorityModule();
         }
         else
         {
            this.priorityMode = param1;
         }
         this.discountType = param2;
         this.percentage = param3;
      }
      
      public static function get instance() : LMDiscountInfoCommand
      {
         return _instance || (_instance = new LMDiscountInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 201;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
         this.discountType = param1.readShort();
         this.percentage = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(201);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.discountType);
         param1.writeDouble(this.percentage);
      }
   }
}

