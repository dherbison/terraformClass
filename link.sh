for i in *
do
	echo "ln $i ~/environment/$i"
	ln $i ~/environment/$i
done
