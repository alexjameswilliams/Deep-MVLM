import imageio
import argparse
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits import mplot3d


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("depth_map")
	parser.add_argument("plot3d")
	args = parser.parse_args()

	depth_map = np.array(imageio.imread(args.depth_map))
	depth_map = 1-depth_map
	# depth_map = np.clip(depth_map, 12000, 30000)
	print(depth_map.shape)

	fig = plt.figure(figsize=(15, 15))
	ax = plt.axes(projection='3d')
	x = np.linspace(0, depth_map.shape[1], num=depth_map.shape[1])
	y = np.linspace(0, depth_map.shape[0], num=depth_map.shape[0])
	X, Y = np.meshgrid(x, y)
	ax.plot_surface(X, Y, depth_map, rstride=1, cstride=1, cmap='viridis', edgecolor='none')
	plt.savefig(args.plot3d)
	plt.show()
