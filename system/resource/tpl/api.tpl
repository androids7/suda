
namespace db;

use Query;

class <?php echo htmlspecialchars($_SQL->name) ?>

{
	<?php 
		$primary_key=key($_SQL->primary);
		$primary_type=preg_match('/int/i', current($_SQL->primary))?'int':'string'; 
	?>
    <?php $set_update=[] ; $set_create=[] ;$create_params=[];$update_params=[]; ?>
    <?php foreach($_SQL->fields() as $name => $type): ?><?php  $type=preg_match('/int/i', $type)?'int':'string';$set_update[]= "'$name'=>\${$name}";?>
      <?php if($this->getAuto() == $name): ?>
        <?php $update_params[]=$type .' $'.$name; ?>
       <?php else: ?>
        <?php $set_create[]= "'$name'=>\${$name}"; $create_params[]=$type .' $'.$name; ?>
       <?php endif; ?>
    <?php endforeach; ?>
    <?php $set_update=implode(',',$set_update);  $set_create=implode(',',$set_create);  $update_params=array_merge($update_params, $create_params); $create_params=implode(',', $create_params);$update_params=implode(',', $update_params);?>
	
	/**
	* Create A Item
	* @return  the id of item
	*/
    public function create(<?php echo htmlspecialchars($create_params) ?>)
    {
        return Query::insert('<?php echo htmlspecialchars($this->getTableName()) ?>',[<?php echo($set_create) ?>]);
    }
	
	/**
	*  	Delete A Item By Primary Key
	*	@return  rows
	*/
	public function delete(<?php echo htmlspecialchars($primary_type) ?> $<?php echo htmlspecialchars($primary_key) ?>){
        return Query::delete('<?php echo htmlspecialchars($this->getTableName()) ?>',['<?php echo htmlspecialchars($primary_key) ?>'=>$<?php echo htmlspecialchars($primary_key) ?>]);
    }
	
	/**
	*  	get A Item By Primary Key 
	* 	@return  item
	*/  
	public function get(<?php echo htmlspecialchars($primary_type) ?> $<?php echo htmlspecialchars($primary_key) ?>)
    {
        return ($get=Query::where('<?php echo htmlspecialchars($this->getTableName()) ?>', <?php echo htmlspecialchars($this->getFieldsStr()) ?>,['<?php echo htmlspecialchars($primary_key) ?>'=>$<?php echo htmlspecialchars($primary_key) ?>])->fetch()) ? $get  : false;
    }
	
	<?php foreach($_SQL->keys as $key => $type): ?> 
	
	/**
	* Get By <?php echo htmlspecialchars($key) ?> <?php echo htmlspecialchars($type) ?>  
	*/<?php $type=preg_match('/int/i', $type)?'int':'string'; ?> 
	public function getBy<?php echo htmlspecialchars(ucfirst($key)) ?>(<?php echo htmlspecialchars($type) ?> $<?php echo htmlspecialchars($key) ?>)
    {
        return ($get=Query::where('<?php echo htmlspecialchars($this->getTableName()) ?>', <?php echo htmlspecialchars($this->getFieldsStr($key)) ?>,['<?php echo htmlspecialchars($key) ?>'=>$<?php echo htmlspecialchars($key) ?>])->fetch()) ? $get  : false;
    }
	
	<?php endforeach; ?> 
    public function update(<?php echo htmlspecialchars($primary_type) ?> $<?php echo htmlspecialchars($primary_key) ?>,<?php echo htmlspecialchars($this->updataParams()) ?>){
	   $sets=[];
	   <?php foreach($_SQL->fields() as $name => $type): ?> 
	   if  (!is_null($<?php echo htmlspecialchars($name) ?>))
	   {
		   $sets['<?php echo htmlspecialchars($name) ?>']=$<?php echo htmlspecialchars($name) ?>;
	   }
       <?php endforeach; ?> 
       return Query::update('<?php echo htmlspecialchars($this->getTableName()) ?>',$sets,['<?php echo htmlspecialchars($primary_key) ?>'=>$<?php echo htmlspecialchars($primary_key) ?>]); 
    }
    public function list(int $page=1, int $count=10)
    {
        return Query::where('<?php echo htmlspecialchars($this->getTableName()) ?>', <?php echo htmlspecialchars($this->getFieldsStr()) ?>, '1', [], [$page, $count])->fetchAll();
    }
}