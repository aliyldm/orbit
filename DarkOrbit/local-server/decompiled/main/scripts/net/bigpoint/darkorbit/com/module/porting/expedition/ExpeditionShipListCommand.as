package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ExpeditionShipListCommand implements IModule
   {
      
      private static var _instance:ExpeditionShipListCommand;
      
      public var shipCommands:Vector.<ExpeditionShipCommand>;
      
      public function ExpeditionShipListCommand(param1:Vector.<ExpeditionShipCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.shipCommands = new Vector.<ExpeditionShipCommand>();
         }
         else
         {
            this.shipCommands = param1;
         }
      }
      
      public static function get instance() : ExpeditionShipListCommand
      {
         return _instance || (_instance = new ExpeditionShipListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -19971;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ExpeditionShipCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.shipCommands.length > 0)
         {
            this.shipCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ExpeditionShipCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.shipCommands.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ExpeditionShipCommand = null;
         param1.writeShort(-19971);
         param1.writeByte(this.shipCommands.length);
         for each(_loc2_ in this.shipCommands)
         {
            _loc2_.write(param1);
         }
      }
   }
}

