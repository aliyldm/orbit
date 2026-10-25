package net.bigpoint.darkorbit.com.module.porting.synthesis
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SynthesisListCommand implements IModule
   {
      
      private static var _instance:SynthesisListCommand;
      
      public var groups:Vector.<SynthesisGroupCommand>;
      
      public function SynthesisListCommand(param1:Vector.<SynthesisGroupCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.groups = new Vector.<SynthesisGroupCommand>();
         }
         else
         {
            this.groups = param1;
         }
      }
      
      public static function get instance() : SynthesisListCommand
      {
         return _instance || (_instance = new SynthesisListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17270;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SynthesisGroupCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.groups.length > 0)
         {
            this.groups.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SynthesisGroupCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.groups.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SynthesisGroupCommand = null;
         param1.writeShort(17270);
         param1.writeShort(this.groups.length);
         for each(_loc2_ in this.groups)
         {
            _loc2_.write(param1);
         }
      }
   }
}

