package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CCInitCommand implements IModule
   {
      
      private static var _instance:CCInitCommand;
      
      public var commands:Vector.<CCommandModule>;
      
      public function CCInitCommand(param1:Vector.<CCommandModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.commands = new Vector.<CCommandModule>();
         }
         else
         {
            this.commands = param1;
         }
      }
      
      public static function get instance() : CCInitCommand
      {
         return _instance || (_instance = new CCInitCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -21591;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CCommandModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.commands.length > 0)
         {
            this.commands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CCommandModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.commands.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CCommandModule = null;
         param1.writeShort(-21591);
         param1.writeShort(this.commands.length);
         for each(_loc2_ in this.commands)
         {
            _loc2_.write(param1);
         }
      }
   }
}

