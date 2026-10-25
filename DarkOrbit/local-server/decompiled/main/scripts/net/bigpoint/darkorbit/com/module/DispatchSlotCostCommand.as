package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchSlotCostCommand implements IModule
   {
      
      private static var _instance:DispatchSlotCostCommand;
      
      public var slotCosts:Vector.<DispatchSlotModule>;
      
      public function DispatchSlotCostCommand(param1:Vector.<DispatchSlotModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.slotCosts = new Vector.<DispatchSlotModule>();
         }
         else
         {
            this.slotCosts = param1;
         }
      }
      
      public static function get instance() : DispatchSlotCostCommand
      {
         return _instance || (_instance = new DispatchSlotCostCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13901;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:DispatchSlotModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.slotCosts.length > 0)
         {
            this.slotCosts.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = DispatchSlotModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.slotCosts.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:DispatchSlotModule = null;
         param1.writeShort(-13901);
         param1.writeByte(this.slotCosts.length);
         for each(_loc2_ in this.slotCosts)
         {
            _loc2_.write(param1);
         }
      }
   }
}

